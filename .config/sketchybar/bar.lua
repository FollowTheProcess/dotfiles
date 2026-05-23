local colors = require("colors")

-- Like calling sketchybar --bar [stuff]
sbar.bar(
    {
        position = "top",
        height = 40,
        blur_radius = 30,
        color = colors.with_alpha(colors.mantle, 0.8),
        shadow = true,
        sticky = true,
        padding_left = 10,
        padding_right = 10,
        notch_width = 210,
        margin = 2,
        corner_radius = 8,
    }
)
