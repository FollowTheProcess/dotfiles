-- The Catppuccin Macchiato palette --

---Packed 0xAARRGGBB color value.
---@alias Color integer

---@class Palette
---@field rosewater Color
---@field flamingo Color
---@field pink Color
---@field mauve Color
---@field red Color
---@field maroon Color
---@field peach Color
---@field yellow Color
---@field green Color
---@field teal Color
---@field sky Color
---@field sapphire Color
---@field blue Color
---@field lavender Color
---@field text Color
---@field subtext1 Color
---@field subtext0 Color
---@field overlay2 Color
---@field overlay1 Color
---@field overlay0 Color
---@field surface2 Color
---@field surface1 Color
---@field surface0 Color
---@field base Color
---@field mantle Color
---@field crust Color
---@field white Color
---@field with_alpha fun(color: Color, alpha: number): Color

---@type Palette
return {
    rosewater = 0xfff4dbd6,
    flamingo = 0xfff0c6c6,
    pink = 0xfff5bde6,
    mauve = 0xffc6a0f6,
    red = 0xffed8796,
    maroon = 0xffee99a0,
    peach = 0xfff5a97f,
    yellow = 0xffeed49f,
    green = 0xffa6da95,
    teal = 0xff8bd5ca,
    sky = 0xff91d7e3,
    sapphire = 0xff7dc4e4,
    blue = 0xff8aadf4,
    lavender = 0xffb7bdf8,
    text = 0xffcad3f5,
    subtext1 = 0xffb8c0e0,
    subtext0 = 0xffa5adcb,
    overlay2 = 0xff939ab7,
    overlay1 = 0xff8087a2,
    overlay0 = 0xff6e738d,
    surface2 = 0xff5b6078,
    surface1 = 0xff494d64,
    surface0 = 0xff363a4f,
    base = 0xff24273a,
    mantle = 0xff1e2030,
    crust = 0xff181926,
    -- white is not actually a catppuccin colour, but it's useful either way
    white = 0xffffffff,

    ---Returns `color` with its alpha channel replaced.
    ---Out-of-range alphas return the input unchanged.
    ---@param color Color Packed 0xAARRGGBB color.
    ---@param alpha number Opacity in [0.0, 1.0].
    ---@return Color
    with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then return color end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end
}
