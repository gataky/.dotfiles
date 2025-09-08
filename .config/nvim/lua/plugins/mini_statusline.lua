now(function()
    local statusline = require('mini.statusline')

    local error = "DiagnosticError"
    local warn = "DiagnosticWarn"
    local info = "DiagnosticInfo"
    local hint = "DiagnosticHint"
    local diag_signs = {
      ERROR = string.format("%%#%s#%s", error, " "),
      WARN  = string.format("%%#%s#%s", warn, " "),
      INFO  = string.format("%%#%s#%s", info, " "),
      HINT  = string.format("%%#%s#%s", hint, ""),
    }

    local create_statusline_separator = function(before_hl, after_hl, char)
        local hl_name = string.format("Statusline%s%s", before_hl, after_hl)
        vim.cmd(
            string.format(
                [[ hi! %s guifg=%s guibg=%s ]],
                hl_name,
                string.format("#%06x", vim.api.nvim_get_hl_by_name(before_hl, true).background),
                string.format("#%06x", vim.api.nvim_get_hl_by_name(after_hl, true).background)
            )
        )
        return "%#" .. hl_name .. "#" .. char
    end

    vim.cmd([[hi! MiniStatuslineGit guibg=#0085cc guifg=#ebdbb2]])
    vim.cmd([[hi! MiniStatuslineFilename guibg=#504945 guifg=#ebdbb2]])


    local active_content = function()
        local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
        local git           = statusline.section_git({ trunc_width = 40 })
        local diagnostics   = statusline.section_diagnostics({
            trunc_width = 75, use_icons = true, signs = diag_signs,
        })
        local lsp           = statusline.section_lsp({ trunc_width = 75 })
        local filename      = statusline.section_filename({ trunc_width = 140 })
        local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
        local search        = statusline.section_searchcount({ trunc_width = 75 })

        return statusline.combine_groups {
            { hl = mode_hl,                  strings = { mode } },
            "%<", -- Mark general truncate point
            create_statusline_separator(mode_hl, "MiniStatuslineGit", ""),
            { hl = "MiniStatuslineGit", strings = { git } },
            create_statusline_separator("MiniStatuslineGit", "MiniStatuslineFilename", ""),
            { hl = "MiniStatuslineFilename", strings = { filename } },
            create_statusline_separator("MiniStatuslineFilename", "MiniStatuslineFileinfo", ""),
            "%=", -- End left alignment
            { hl = "MiniStatuslineFileinfo", strings = { diagnostics } },
            create_statusline_separator("MiniStatuslineFileinfo", "MiniStatuslineModeOther", ""),
            { hl = "MiniStatuslineModeOther", strings = { lsp } },
            create_statusline_separator("MiniStatuslineModeOther", mode_hl, ""),
            { hl = mode_hl,                   strings = { fileinfo } },
            { hl = mode_hl,                   strings = { search } },
        }
    end

    statusline.setup({ content = { active = active_content } })
end)