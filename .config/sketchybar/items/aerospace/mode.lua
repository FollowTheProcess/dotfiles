-- Display whether we're in service mode
local colors = require("colors")

sbar.add("event", "aerospace_mode_change")

local mode = sbar.add("item", "aerospace_mode", {
    position = "left",
    drawing = false,
    updates = true,
    icon = { drawing = false },
    label = { color = colors.peach },
})

mode:subscribe("aerospace_mode_change", function(env)
    if env.MODE and env.MODE ~= "main" then
        mode:set({ drawing = true, label = env.MODE })
    else
        mode:set({ drawing = false })
    end
end)

return mode
