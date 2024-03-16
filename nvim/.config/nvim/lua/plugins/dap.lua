return {
    {
        "nvim-dap-virtual-text",
        opts = {
            enabled = false,
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "mfussenegger/nvim-dap-python",
                config = function()
                    local path = require("mason-registry")
                        .get_package("debugpy")
                        :get_install_path()
                    require("dap-python").setup(path .. "/venv/bin/python")
                    require("dap-python").test_runner = "pytest"
                end,
            },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            vim.api.nvim_set_hl(
                0,
                "DapBreakpoint",
                { ctermbg = 0, fg = "#e00d0d" }
            )
            vim.api.nvim_set_hl(
                0,
                "DapStopped",
                { ctermbg = 0, fg = "#6be612" }
            )
            vim.fn.sign_define(
                "DapBreakpoint",
                { text = "", texthl = "DapBreakpoint" }
            )
            vim.fn.sign_define(
                "DapStopped",
                { text = "󰁔", texthl = "DapStopped" }
            )

            local function DebugMappingKeyBindings(active)
                local opts = { noremap = true, silent = true, buffer = false }
                if active then
                    local set = vim.keymap.set
                    set(
                        "n",
                        "c",
                        "<cmd>lua require('dap').continue()<CR>",
                        opts
                    )
                    set(
                        "n",
                        "n",
                        "<cmd>lua require('dap').step_over()<CR>",
                        opts
                    )
                    set(
                        "n",
                        "s",
                        "<cmd>lua require('dap').step_into()<CR>",
                        opts
                    )
                    set(
                        "n",
                        "t",
                        "<cmd>lua require('dap').run_to_cursor()<CR>",
                        opts
                    )
                    set(
                        "n",
                        "o",
                        "<cmd>lua require('dap').step_out()<CR>",
                        opts
                    )

                    set("n", "u", "<cmd>lua require('dap').up()<CR>", opts)
                    set("n", "d", "<cmd>lua require('dap').down()<CR>", opts)
                    set(
                        "n",
                        "b",
                        "<cmd>lua require('dap').toggle_breakpoint()<CR>",
                        opts
                    )
                    set(
                        "n",
                        "q",
                        "<cmd>lua require('dap').disconnect()<CR>",
                        opts
                    )

                    set(
                        "n",
                        "r",
                        "<cmd>lua require('dap').repl.open()<CR>",
                        opts
                    )
                    set("n", "v", function()
                        local height = math.floor((vim.o.lines * 0.75))
                        local width = math.floor((vim.o.columns * 0.75))

                        require("dapui").float_element(
                            "scopes",
                            {
                                enter = true,
                                width = width,
                                height = height,
                                position = "center",
                            }
                        )
                    end)
                else
                    local del = vim.keymap.del
                    local keys = {
                        "c",
                        "n",
                        "s",
                        "t",
                        "o",
                        "u",
                        "d",
                        "b",
                        "q",
                        "r",
                        "v",
                    }
                    for _, key in ipairs(keys) do
                        del("n", key)
                    end
                end
            end

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
                DebugMappingKeyBindings(true)
            end

            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
                pcall(DebugMappingKeyBindings, false)
            end

            dap.listeners.after.event_terminated["dapui_config"] = function()
                dapui.close()
                pcall(DebugMappingKeyBindings, false)
            end
        end,
    },
}
