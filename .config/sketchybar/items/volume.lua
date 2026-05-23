-- Show speaker/headphones volume
local volume = sbar.add("item", "volume", {
    position = "right",
})

---Returns the SF Symbol matching a volume level
---Buckets: muted (0), low (1-29), medium (30-59), high (60+).
---@param percent integer Volume percentage in [0, 100].
---@return string SF Icon for the volume.
local function icon_for(percent)
    if percent >= 60 then
        return "􀊩"
    elseif percent >= 30 then
        return "􀊧"
    elseif percent >= 1 then
        return "􀊥"
    else
        return "􀊣"
    end
end

volume:subscribe("volume_change", function(env)
    local percent = tonumber(env.INFO) or 0
    volume:set(
        {
            icon = icon_for(percent),
            label = percent .. "%",
        }
    )
end)

return volume
