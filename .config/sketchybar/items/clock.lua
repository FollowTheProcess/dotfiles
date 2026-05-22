local settings = require("settings")

-- Show the date/time on the right
local clock = sbar.add("item", "clock", {
    position = "right",
    update_freq = 30,
    icon = {
        string = "􀧞",
    }
})

clock:subscribe({ "routine", "forced", "system_woke" }, function()
    clock:set({ label = os.date("%a %d %b %H:%M") })
end
)

return clock
