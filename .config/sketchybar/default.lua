local colors = require("colors")
local settings = require("settings")

-- Like calling sketchybar --default [stuff]
sbar.default(
    {
        updates = "when_shown",
        padding_left = settings.padding,
        padding_right = settings.padding,
        icon = {
            font = {
                family = settings.font.icon.family,
                style = settings.font.icon.style,
                size = settings.font.icon.size,
            },
            color = colors.white,
            padding_left = settings.padding,
            padding_right = settings.padding,
        },
        label = {
            font = {
                family = settings.font.label.family,
                style = settings.font.label.style,
                size = settings.font.label.size,
            },
            color = colors.white,
            padding_left = settings.padding,
            padding_right = settings.padding,
        },
    }
)
