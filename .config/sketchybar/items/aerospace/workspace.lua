-- Show aerospace workspaces along with the icons of apps inside each.
local colors = require("colors")
local icons = require("icons")

-- [sid] = item table. Mirrors which space.N tiles currently exist so we can
-- diff against `aerospace list-workspaces --all` without round-tripping
-- through `sketchybar --query bar`.
local tiles = {}

---Split a string into a list of non-empty lines.
---@param s string
---@return string[]
local function lines(s)
    local result = {}
    for line in s:gmatch("[^\n]+") do
        table.insert(result, line)
    end
    return result
end

---Parse `aerospace list-windows --all --format '%{workspace}\t%{app-name}'`
---output into a workspace -> deduplicated app-name list mapping.
---@param out string Raw stdout from aerospace.
---@return table<string, string[]> Workspace: [apps running in it]
local function parse_windows(out)
    local by_ws = {}
    local seen = {}
    for _, line in ipairs(lines(out)) do
        local ws, app = line:match("^([^\t]+)\t(.+)$")
        if ws and app then
            local key = ws .. "|" .. app
            if not seen[key] then
                seen[key] = true
                by_ws[ws] = by_ws[ws] or {}
                table.insert(by_ws[ws], app)
            end
        end
    end
    return by_ws
end

---Build the concatenated icon-font string for a list of app names.
---Unknown apps fall back to icons.Default.
---@param apps string[]
---@return string
local function icons_for(apps)
    local parts = {}
    for _, app in ipairs(apps) do
        table.insert(parts, icons[app] or icons.Default)
    end
    return table.concat(parts)
end

sbar.add("event", "aerospace_workspace_change")

-- Hidden controller. Two jobs: event sink for aerospace_workspace_change,
-- and positional anchor that every space.N tile is moved before so the
-- workspace run stays contiguous and leftmost even when tiles are added
-- at runtime.
local controller = sbar.add("item", "spaces_controller", {
    drawing = false,
    updates = true,
})

---Build the per-refresh state for a single tile.
---@param icon_str string Concatenated icon-font string, empty when no apps.
---@param focused boolean
---@return table sbar set props
local function state_for(icon_str, focused)
    local has_icons = icon_str ~= ""
    if focused then
        return {
            drawing = true,
            background = {
                drawing = true,
                color = colors.with_alpha(colors.mauve, 0.53),
            },
            label = {
                drawing = has_icons,
                string = has_icons and icon_str or "",
            },
        }
    end
    if has_icons then
        return {
            drawing = true,
            background = {
                drawing = true,
                color = colors.with_alpha(colors.surface0, 0.5),
            },
            label = { drawing = true, string = icon_str },
        }
    end
    return {
        drawing = false,
        background = { drawing = false },
        label = { drawing = false, string = "" },
    }
end

local function add_tile(sid)
    local name = "space." .. sid
    local tile = sbar.add("item", name, {
        position = "left",
        icon = {
            string = sid,
            padding_left = 10,
            padding_right = 6,
        },
        label = {
            font = {
                family = "sketchybar-app-font",
                style = "Regular",
                size = 14.0,
            },
            padding_left = 0,
            padding_right = 10,
            drawing = false,
        },
        background = {
            color = colors.with_alpha(colors.surface0, 0.5),
            corner_radius = 6,
            height = 26,
            drawing = false,
        },
        click_script = "aerospace workspace " .. sid,
    })
    tiles[sid] = tile
end

local function remove_tile(sid)
    sbar.remove("space." .. sid)
    tiles[sid] = nil
end

---Reconcile the live workspace list against the in-memory tiles table.
---@param live_sids string[]
local function reconcile(live_sids)
    local live_set = {}
    for _, sid in ipairs(live_sids) do
        live_set[sid] = true
        if not tiles[sid] then add_tile(sid) end
    end
    for sid in pairs(tiles) do
        if not live_set[sid] then remove_tile(sid) end
    end
end

---@param env table|nil Event env. env.FOCUSED_WORKSPACE may be missing on
---cold-start; we recurse once with it filled in from a fallback query.
local function refresh(env)
    local focused = env and env.FOCUSED_WORKSPACE
    if not focused or focused == "" then
        sbar.exec("aerospace list-workspaces --focused", function(out)
            local trimmed = (out:gsub("%s+$", ""))
            -- Aerospace daemon not running. Bail and let the next event-driven
            -- refresh retry; recursing on empty would loop forever.
            if trimmed == "" then return end
            refresh({ FOCUSED_WORKSPACE = trimmed })
        end)
        return
    end

    sbar.exec("aerospace list-workspaces --all", function(ws_out)
        local live_sids = lines(ws_out)
        sbar.exec(
            "aerospace list-windows --all --format '%{workspace}\t%{app-name}'",
            function(win_out)
                local by_ws = parse_windows(win_out)
                reconcile(live_sids)
                for _, sid in ipairs(live_sids) do
                    local icon_str = by_ws[sid] and icons_for(by_ws[sid]) or ""
                    tiles[sid]:set(state_for(icon_str, sid == focused))
                end
                -- Reorder pass: SbarLua has no move primitive, so shell out.
                -- Idempotent and cheap (one process per refresh) and removes
                -- the class of bugs where dynamically-added tiles land at
                -- the wrong end of the workspace run.
                local move_args = {}
                for _, sid in ipairs(live_sids) do
                    table.insert(move_args,
                        "--move space." .. sid .. " before spaces_controller")
                end
                if #move_args > 0 then
                    sbar.exec("sketchybar " .. table.concat(move_args, " "))
                end
            end
        )
    end)
end

controller:subscribe("aerospace_workspace_change", refresh)

-- Cold-start kick: no env, so refresh falls back to querying focused.
refresh()

return controller
