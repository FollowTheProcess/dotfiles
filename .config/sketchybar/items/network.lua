-- Network state + throughput for the default-route interface.
local colors = require("colors")
local settings = require("settings")

---Format a non-negative byte count as a human-readable string with /s suffix.
---1024-based units. Bytes are printed as integers, larger units to 1 decimal.
---@param bytes integer
---@return string
local function human_bytes(bytes)
    local units = { "B", "KiB", "MiB", "GiB", "TiB" }
    local i = 1
    local n = bytes
    while n >= 1024 and i < #units do
        n = n / 1024
        i = i + 1
    end
    if i == 1 then
        return string.format("%d %s/s", n, units[i])
    end
    return string.format("%.1f %s/s", n, units[i])
end

---Extract the default route's interface name from `route -n get default`.
---@param stdout string
---@return string|nil
local function parse_default_iface(stdout)
    return stdout:match("interface:%s*(%S+)")
end

---Extract the first IPv4 address and detect any utun mention in scutil --nwi.
---VPN detection wins over IP: a utun interface present means we're tunnelled
---even if scutil also reports a physical address on en0.
---@param stdout string
---@return string|nil ip, boolean is_vpn
local function parse_ip_and_vpn(stdout)
    local ip = stdout:match("address%s*:%s*([%d%.]+)")
    local is_vpn = stdout:find("utun", 1, true) ~= nil
    return ip, is_vpn
end

---Pull RX/TX bytes for `iface` out of `netstat -ibn`. Returns nil/nil when
---no row matches (e.g. iface is empty or disappeared).
---Column 7 = Ibytes, column 10 = Obytes on macOS netstat output.
---@param stdout string
---@param iface string
---@return integer|nil rx, integer|nil tx
local function parse_counters(stdout, iface)
    if not iface or iface == "" then return nil, nil end
    for line in stdout:gmatch("[^\n]+") do
        local name = line:match("^(%S+)")
        if name == iface then
            local fields = {}
            for f in line:gmatch("%S+") do
                fields[#fields + 1] = f
            end
            local rx = tonumber(fields[7])
            local tx = tonumber(fields[10])
            if rx and tx then return rx, tx end
        end
    end
    return nil, nil
end

local ARROW_FONT = {
    family = settings.font.label.family,
    style = settings.font.label.style,
    size = 10.0,
}


-- Label width is pinned so the two arrows stay vertically aligned regardless
-- of throughput magnitude (e.g. "589 B/s" vs "2.5 KiB/s"). Right-aligned text
-- keeps the unit suffix flush against the right edge of the cluster.
local LABEL_WIDTH = 64

local wifi_up     = sbar.add("item", "network.up", {
    position = "right",
    padding_left = -5,
    width = 0,
    y_offset = 6,
    icon = {
        string = "􀄨",
        padding_right = 0,
        font = ARROW_FONT,
        color = colors.overlay1,
    },
    label = {
        string = "0 B/s",
        font = ARROW_FONT,
        color = colors.overlay1,
        width = LABEL_WIDTH,
        align = "right",
    },
})

local wifi_down   = sbar.add("item", "network.down", {
    position = "right",
    padding_left = -5,
    y_offset = -4,
    icon = {
        string = "􀄩",
        padding_right = 0,
        font = ARROW_FONT,
        color = colors.overlay1,
    },
    label = {
        string = "0 B/s",
        font = ARROW_FONT,
        color = colors.overlay1,
        width = LABEL_WIDTH,
        align = "right",
    },
})

local wifi        = sbar.add("item", "network.wifi", {
    position = "right",
    update_freq = 2,
    icon = {
        string = "􀙇",
        color = colors.white,
    },
    label = {
        drawing = false,
    },
})


-- Module-level state. Closure-captured, only refresh() writes it.
local prev              = { iface = "", t = 0, rx = 0, tx = 0 }

local ICON_CONNECTED    = "􀙇"
local ICON_VPN          = "􃔷"
local ICON_DISCONNECTED = "􀙈"

---Decide the wifi item visual state from the parsed network info.
---@param ip string|nil
---@param is_vpn boolean
---@return table set_args
local function wifi_state(ip, is_vpn)
    if is_vpn then
        return {
            icon = { string = ICON_VPN, color = colors.mauve },
            label = { drawing = false },
        }
    elseif ip then
        return {
            icon = { string = ICON_CONNECTED, color = colors.white },
            label = { drawing = false },
        }
    end
    return {
        icon = { string = ICON_DISCONNECTED, color = colors.overlay1 },
        label = {
            drawing = true,
            string = "offline",
            color = colors.overlay1,
        },
    }
end

---Compute up/down bytes/sec, applying the same delta-rejection guards as the
---legacy bash script: iface flip, sleep gaps (dt >= 60s), non-positive dt,
---counter rollback. Returns 0/0 on reject. Always updates prev.
---@param iface string
---@param rx integer|nil
---@param tx integer|nil
---@return integer up_bps, integer down_bps
local function compute_throughput(iface, rx, tx)
    local now = os.time()
    local dt = now - prev.t
    local up_bps, down_bps = 0, 0
    if iface ~= "" and iface == prev.iface and dt > 0 and dt < 60
        and rx and tx and rx >= prev.rx and tx >= prev.tx then
        down_bps = math.floor((rx - prev.rx) / dt)
        up_bps = math.floor((tx - prev.tx) / dt)
    end
    prev = { iface = iface, t = now, rx = rx or 0, tx = tx or 0 }
    return up_bps, down_bps
end

---Apply throughput to the up/down items. Hides them entirely when offline,
---greys them when 0 B/s, colours them when active.
---@param connected boolean
---@param up_bps integer
---@param down_bps integer
local function apply_throughput(connected, up_bps, down_bps)
    if not connected then
        wifi_up:set({ drawing = false })
        wifi_down:set({ drawing = false })
        return
    end
    local up_color = up_bps == 0 and colors.overlay1 or colors.peach
    local down_color = down_bps == 0 and colors.overlay1 or colors.green
    wifi_up:set({
        drawing = true,
        icon = { color = up_color },
        label = { string = human_bytes(up_bps), color = up_color },
    })
    wifi_down:set({
        drawing = true,
        icon = { color = down_color },
        label = { string = human_bytes(down_bps), color = down_color },
    })
end

---Fan out the exec calls and apply once both paths have completed. Two
---completions: (1) route -> netstat chained, (2) scutil standalone.
local function refresh()
    local pass = { done = 0 }
    local function maybe_apply()
        pass.done = pass.done + 1
        if pass.done < 2 then return end
        local iface = pass.iface or ""
        local ip = pass.ip
        local is_vpn = pass.is_vpn or false
        local connected = is_vpn or (ip ~= nil)
        wifi:set(wifi_state(ip, is_vpn))
        local up_bps, down_bps = compute_throughput(iface, pass.rx, pass.tx)
        apply_throughput(connected, up_bps, down_bps)
    end

    sbar.exec("route -n get default 2>/dev/null", function(out)
        pass.iface = parse_default_iface(out)
        sbar.exec("netstat -ibn", function(net_out)
            pass.rx, pass.tx = parse_counters(net_out, pass.iface or "")
            maybe_apply()
        end)
    end)

    sbar.exec("scutil --nwi", function(out)
        pass.ip, pass.is_vpn = parse_ip_and_vpn(out)
        maybe_apply()
    end)
end

wifi:subscribe({ "routine", "forced", "wifi_change", "system_woke" }, refresh)

return wifi
