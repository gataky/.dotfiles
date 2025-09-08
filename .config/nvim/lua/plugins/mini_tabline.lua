now(function()
    local tabline = require('mini.tabline')

    local format = function(buf_id, label)
        local suffix = vim.bo[buf_id].modified and '+ ' or ''
        return tabline.default_format(buf_id, label) .. suffix
    end
    tabline.setup({
        format = format,
    })
end)