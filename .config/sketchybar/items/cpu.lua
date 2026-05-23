-- Show an updating CPU %
local cpu = sbar.add("item", "cpu", {
    position = "right",
    update_freq = 2,
    icon = "􀫥"
})

local n_cores = 1
sbar.exec("sysctl -n hw.logicalcpu", function(out)
    n_cores = tonumber(out:match("(%d+)")) or 1
end)

cpu:subscribe({ "routine", "forced", "system_woke" }, function()
    sbar.exec("ps -A -o %cpu=", function(out)
        local sum = 0
        for line in out:gmatch("[^\n]+") do
            sum = sum + (tonumber(line) or 0)
        end
        local percent = math.floor(sum / n_cores + 0.5)
        cpu:set({ label = percent .. "%" })
    end)
end)

cpu:subscribe("mouse.clicked", function(env)
    sbar.exec("open -a 'Activity Monitor'")
end)
