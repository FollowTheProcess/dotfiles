-- Show battery percentage and an appropriate icon
local battery = sbar.add("item", "battery", {
    position = "right",
    update_freq = 120,
})

---Returns the SF Symbol matching a battery level
---@param percent integer Battery percentage in [0, 100].
---@param charging boolean Whether the battery is charging.
---@return string SF Icon for the battery percentage.
local function icon_for(percent, charging)
    if charging then return "􀢋" end
    if percent >= 90 then
        return "􀛨"
    elseif percent >= 60 then
        return "􀺸"
    elseif percent >= 30 then
        return "􀺶"
    elseif percent >= 10 then
        return "􀛩"
    else
        return "􀛪"
    end
end

battery:subscribe({ "routine", "forced", "system_woke", "power_source_change" }, function()
    sbar.exec("pmset -g batt", function(out)
        local percent = tonumber(out:match("(%d+)%%"))
        if not percent then return end
        local on_ac = out:find("AC Power", 1, true) ~= nil
        battery:set({ icon = icon_for(percent, on_ac), label = percent .. "%" })
    end)
end)

return battery
