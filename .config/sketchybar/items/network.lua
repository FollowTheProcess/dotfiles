-- Network connection state for the default-route interface.
local colors = require("colors")

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

local wifi              = sbar.add("item", "network.wifi", {
    position = "right",
    update_freq = 15,
    click_script = "open 'x-apple.systempreferences:com.apple.Network-Settings.extension'",
    icon = {
        string = "􀙇",
        color = colors.white,
    },
    label = {
        drawing = false,
    },
})

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

---Read the current network info and apply the wifi item visual state.
local function refresh()
    sbar.exec("scutil --nwi", function(out)
        local ip, is_vpn = parse_ip_and_vpn(out)
        wifi:set(wifi_state(ip, is_vpn))
    end)
end

wifi:subscribe({ "routine", "forced", "wifi_change", "system_woke" }, refresh)

return wifi
