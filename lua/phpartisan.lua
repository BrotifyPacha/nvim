
local M = {}

function M.toggleArtisanServer()
    local job = vim.g.artisan_serve_job
    if job == nil then
        job = vim.fn.jobstart('php artisan serve', { detach = 1 })
        vim.api.nvim_set_var('artisan_serve_job', job)
        print('Serving...')
    else
        print('Stopped')
        vim.fn.jobstop(job)
        vim.g.artisan_serve_job = nil
    end
end

return M
