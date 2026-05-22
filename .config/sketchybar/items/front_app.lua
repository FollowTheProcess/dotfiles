-- Show the focused app's icon and name, with a chevron divider in front.
-- Driven by sketchybar's built-in front_app_switched event (NSWorkspace-level,
-- so it works regardless of aerospace).
local icons = require("icons")

-- Both items start hidden and are revealed by aerospace_initialized. Without
-- the gate they'd briefly sit at the left edge of the bar on cold start,
-- before aerospace's async workspace queries land and the tiles slot in.
local chevron = sbar.add("item", "chevron", {
    position = "left",
    drawing = false,
    icon = { string = "❯" },
    label = { drawing = false },
})

local front_app = sbar.add("item", "front_app", {
    position = "left",
    drawing = false,
    -- Override the default `when_shown` so subscriptions still fire while
    -- we're hidden: front_app_switched needs to set icon/label, and
    -- aerospace_initialized needs to reveal the item.
    updates = true,
    icon = {
        font = {
            family = "sketchybar-app-font",
            style = "Regular",
            size = 16.0,
        },
    },
})

front_app:subscribe("front_app_switched", function(env)
    local app = env.INFO
    if not app or app == "" then return end
    front_app:set({
        icon = icons[app] or icons.Default,
        label = app,
    })
end)

-- front_app_switched may fire before aerospace_initialized; the handler
-- above still updates icon/label on the hidden item, so the correct
-- content is already in place when the gate opens.
front_app:subscribe("aerospace_initialized", function()
    chevron:set({ drawing = true })
    front_app:set({ drawing = true })
end)

return front_app
