local function find_venv(root_dir)
    if not root_dir then
        return nil
    end

    local venv_names = { ".venv" }
    for _, venv_name in ipairs(venv_names) do
        local venv_python = root_dir .. "/" .. venv_name .. "/bin/python"
        if vim.fn.executable(venv_python) == 1 then
            return venv_python, root_dir, venv_name
        end
    end
    return nil
end

return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = function(fname)
        -- Handle both buffer number and file path
        local path = type(fname) == "number" and vim.api.nvim_buf_get_name(fname) or fname

        -- Use .git as the root marker for monorepo structure
        local found = vim.fs.find(".git", {
            path = path,
            upward = true,
        })[1]

        return found and vim.fs.dirname(found) or nil
    end,
    on_attach = function(client, bufnr)
        -- Find and configure venv on attach
        local root_dir = client.config.root_dir
        if type(root_dir) == "function" then
            root_dir = root_dir(vim.api.nvim_buf_get_name(bufnr))
        end

        local venv_python, venv_path, venv_name = find_venv(root_dir)
        if venv_python then
            client.config.settings.python = client.config.settings.python or {}
            client.config.settings.python.pythonPath = venv_python
            client.config.settings.python.venvPath = venv_path
            client.config.settings.python.venv = venv_name

            -- Notify the server of the updated settings
            client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
    end,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
            },
        },
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                diagnosticSeverityOverrides = {
                    reportMissingTypeStubs = "none",
                    reportUnknownParameterType = "none",
                    reportUnknownArgumentType = "none",
                    reportUnknownVariableType = "none",
                    reportUnknownMemberType = "none",
                },
            },
        },
    },
    single_file_support = true,
}
