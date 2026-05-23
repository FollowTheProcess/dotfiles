-- Show the current memory usage in %
local memory = sbar.add("item", "memory", {
    position = "right",
    update_freq = 2,
    icon = "􀫦",
})

local total_bytes = 1
sbar.exec("sysctl -n hw.memsize", function(out)
    total_bytes = tonumber(out:match("(%d+)")) or 1
end)

memory:subscribe({ "routine", "forced", "system_woke" }, function()
    sbar.exec("vm_stat", function(out)
        local page_size  = tonumber(out:match("page size of (%d+) bytes")) or 4096
        local anon       = tonumber(out:match("Anonymous pages:%s+(%d+)")) or 0
        local wired      = tonumber(out:match("Pages wired down:%s+(%d+)")) or 0
        local compressed = tonumber(out:match("Pages occupied by compressor:%s+(%d+)")) or 0

        local used       = (anon + wired + compressed) * page_size
        local percent    = math.floor(used * 100 / total_bytes + 0.5)
        memory:set({ label = percent .. "%" })
    end)
end)

return memory
