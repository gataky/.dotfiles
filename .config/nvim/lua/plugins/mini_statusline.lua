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

    -- Custom function to show Greek mode
    local function greek_mode()
        if vim.b.iminsert == 1 or vim.opt.iminsert:get() == 1 then
            return '🇬🇷'  -- '🇬🇷' or whatever indicator you prefer
        end
        return '🇬🇧' -- 🇬🇧
    end

    local create_statusline_separator = function(before_hl, after_hl, char)
        local hl_name = string.format("Statusline%s%s", before_hl, after_hl)
        local before_bg = vim.api.nvim_get_hl(0, { name = before_hl }).bg or 0
        local after_bg = vim.api.nvim_get_hl(0, { name = after_hl }).bg or 0
        vim.cmd(
            string.format(
                [[ hi! %s guifg=%s guibg=%s ]],
                hl_name,
                string.format("#%06x", before_bg),
                string.format("#%06x", after_bg)
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
        local greek         = greek_mode()

        return statusline.combine_groups {
            { hl = mode_hl, strings = { greek } },
            { hl = mode_hl, strings = { mode } },
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
