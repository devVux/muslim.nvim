local fetch_async = require("muslim.prayer").fetch_async
local format_output = require("muslim.prayer").format_output

local M = {
    config = {
        latitude  = nil,
        longitude = nil,
        timezone  = "UTC",
        method    = 3, -- default: Muslim World League (example) — let user override
        school    = 1, -- 0 = Shafi, 1 = Hanafi
        api_url   = "https://api.aladhan.com/v1/timings"
    },
    prayer_time_text = 'Please wait...',
    busy = false
}



M.setup = function(opts)
    -- Check if plenary is installed
    if not pcall(require, 'plenary') then
        vim.notify('[prayer.nvim] please install plenary.nvim', vim.log.levels.WARN)
        return
    end
    -- Check if lualine is intalled
    if not pcall(require, 'lualine') then
        vim.notify('[prayer.nvim] please install lualine', vim.log.levels.WARN)
        return
    end

    -- init config
    opts = opts or {}
    for k, v in pairs(opts) do M.config[k] = v end

    -- validate config
    if not M.config.latitude or not M.config.longitude or not M.config.timezone then
        vim.notify('[prayer.nvim] please set latitude, longitude and timezone', vim.log.levels.WARN)
        return
    end

    -- First run
    M.update_async()

    -- Refresh every 1 hour
    local timer = vim.loop.new_timer()
    timer:start(
        3600 * 1000, -- delay first refresh after 1 hour
        3600 * 1000, -- repeat every hour
        function()
            M.update_async()
        end
    )
end

M.update_async = function()
    if M.busy then return end
    M.busy = true
    M.prayer_time_text = 'Updating prayer times...'

    fetch_async(M.config, function(body)
        M.prayer_time_text = format_output(body)
        M.busy = false

        vim.schedule(function()
            -- Hard refresh
            pcall(function()
                require("lualine").refresh {
                    place = { "statusline", "tabline", "winbar" }
                }
            end)

            -- Force actual redraw (fixes async updates)
            vim.cmd("redrawstatus!")
        end)
    end)
end

M.prayer_time = function()
    return M.prayer_time_text
end

return M
