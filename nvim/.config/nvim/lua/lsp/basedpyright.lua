-- Walk up from `start` looking for a `.venv/bin/python`. The workspace root is
-- not always where the venv lives, so this searches the whole chain rather than
-- checking a single directory.
local function find_venv(start)
    if not start or start == "" then
        return nil
    end

    for dir in vim.fs.parents(start .. "/.") do
        local python = dir .. "/.venv/bin/python"
        if vim.fn.executable(python) == 1 then
            return python, dir .. "/.venv"
        end
    end
    return nil
end

return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },

    -- `root_dir` is a callback in the vim.lsp.config API: nvim passes
    -- (bufnr, on_dir) and starts the client only when on_dir is called.
    -- Returning a value instead is silently ignored and the server never starts.
    root_dir = function(bufnr, on_dir)
        local path = vim.api.nvim_buf_get_name(bufnr)
        if path == "" then
            return
        end

        -- Project markers come first and `.git` last: in a monorepo the git root
        -- is several levels above the actual Python project, and rooting there
        -- puts the project's `.venv` and `src/` out of the server's reach.
        local root = vim.fs.root(bufnr, {
            "pyproject.toml",
            "pyrightconfig.json",
            "setup.py",
            "setup.cfg",
            ".git",
        })

        on_dir(root or vim.fs.dirname(path))
    end,

    -- pythonPath has to be in place before `initialize`, otherwise the server
    -- resolves imports against whichever interpreter it was launched with and
    -- reports every third-party dependency as missing.
    before_init = function(_, config)
        local python, venv = find_venv(config.root_dir)
        if not python then
            -- direnv/an activated shell is the fallback when there is no .venv
            -- in the tree (a uv cache dir elsewhere, say).
            local active = vim.env.VIRTUAL_ENV
            if active and vim.fn.executable(active .. "/bin/python") == 1 then
                python, venv = active .. "/bin/python", active
            end
        end
        if not python then
            return
        end

        config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
            python = {
                pythonPath = python,
                venvPath = vim.fs.dirname(venv),
                venv = vim.fs.basename(venv),
            },
        })
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
}
