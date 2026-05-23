-- Bluetooth audio batteries: AirPods (L/R/case) and over-ear headphones.
--
-- The swift helper at helpers/bt_battery dumps every connected device's
-- L/R/case/single percentages as JSON; a hidden controller polls it once per
-- bluetooth_change/system_woke/routine and fans the four numbers out to the
-- display items below. sbar.exec auto-decodes JSON stdout into a Lua table,
-- so the callback receives `[{name,address,left,right,case,single}, ...]`
-- directly.

local HEADPHONE_NAME = "Tom's Headphones"
local HELPER = os.getenv("HOME") .. "/.config/sketchybar/helpers/bt_battery"

local items = {
    right      = sbar.add("item", "airpods.right", { position = "right", icon = "􀲍", drawing = false }),
    case       = sbar.add("item", "airpods.case", { position = "right", icon = "􀹬", drawing = false }),
    left       = sbar.add("item", "airpods.left", { position = "right", icon = "􀲎", drawing = false }),
    headphones = sbar.add("item", "headphones", { position = "right", icon = "􃍅", drawing = false }),
}

-- com.apple.bluetooth.status is the NSDistributedNotification that fires when
-- a device connects/disconnects or its battery selectors change.
sbar.add("event", "bluetooth_change", "com.apple.bluetooth.status")

local controller = sbar.add("item", "bluetooth_controller", {
    position = "right",
    drawing = false,
    updates = true,
    update_freq = 60,
})

---First device that reports a non-zero L/R/case. Those selectors only respond
---on Apple multi-battery devices, so this is a reliable AirPods discriminator
---without us having to maintain a name allowlist.
---@param devices table[]
---@return table
local function find_airpods(devices)
    for _, d in ipairs(devices) do
        if (d.left or 0) > 0 or (d.right or 0) > 0 or (d.case or 0) > 0 then
            return d
        end
    end
    return {}
end

---@param devices table[]
---@param name string
---@return table
local function find_by_name(devices, name)
    for _, d in ipairs(devices) do
        if d.name == name then return d end
    end
    return {}
end

---Toggle an item on/off based on a battery percent. 0 means "not reporting"
---(e.g. AirPod in case, dead headphones) so we hide rather than show 0%.
---@param item table sbar item handle
---@param value integer|nil
local function apply(item, value)
    if not value or value == 0 then
        item:set({ drawing = false })
    else
        item:set({ drawing = true, label = value .. "%" })
    end
end

local function refresh()
    sbar.exec(HELPER, function(devices)
        if type(devices) ~= "table" then devices = {} end

        local airpods = find_airpods(devices)
        local headphones = find_by_name(devices, HEADPHONE_NAME)

        apply(items.left, airpods.left)
        apply(items.right, airpods.right)
        apply(items.case, airpods.case)
        apply(items.headphones, headphones.single)
    end)
end

controller:subscribe({ "routine", "forced", "bluetooth_change", "system_woke" }, refresh)

return controller
