-- Global bar settings

---@class Settings
---@field padding integer Global padding setting
---@field font table<string, Font> Map of icon|label -> Font

---@class Font
---@field family string The name of the font family e.g. "JetBrains Mono"
---@field style "Bold"|"Regular" The style of the font e.g. "Bold", or "Regular"
---@field size number The font size e.g. 17.0

---@type Settings
return {
    padding = 4,
    font = {
        icon = {
            family = "SF Pro",
            style = "Regular",
            size = 17.0
        },
        label = {
            family = "SF Pro",
            style = "Regular",
            size = 13.0
        }
    }
}
