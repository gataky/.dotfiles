vim.keymap.set('i', 'jk', '<esc>', { noremap = true })
vim.keymap.set('n', '<esc>', ':noh<cr>', { noremap = true })

vim.keymap.set('v', 'gy', '"+y', { noremap = true })

-- Show notification history for ephemeral messages
vim.keymap.set('n', '<leader>nh', function()
    MiniNotify.show_history()
end, { desc = 'Show notification history' })

-- Copy current file relative path and selected line range for Claude Code
vim.keymap.set({ 'n', 'v' }, '<leader>cc', function()
    -- Get file path relative to current working directory
    local filepath = vim.fn.expand('%:.')
    if filepath == '' then
        return
    end

    local start_line, end_line
    local mode = vim.fn.mode()

    if mode == 'v' or mode == 'V' or mode == '\22' then
        -- Get visual mode selection bounds
        start_line = vim.fn.line('v')
        end_line = vim.fn.line('.')
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end
    else
        -- Normal mode: use current line
        start_line = vim.fn.line('.')
        end_line = start_line
    end

    local context_str
    if start_line == end_line then
        context_str = string.format('@%s#L%d', filepath, start_line)
    else
        context_str = string.format('@%s#L%d-%d', filepath, start_line, end_line)
    end

    -- Copy to system clipboard ('+') and default register ('"')
    vim.fn.setreg('+', context_str)
    vim.fn.setreg('"', context_str)
    vim.notify('Copied to clipboard: ' .. context_str, vim.log.levels.INFO)
end, { desc = 'Copy file context for Claude Code' })
