-- must be set before plugins that deal with colors
vim.api.nvim_set_option("termguicolors", true)

require("cmp-conf").setup()
require("lsp-conf").setup()
require("dap-conf")
require("tel-conf")
require("colorizer").setup()
require("mason").setup({})
require("mason-lspconfig").setup({})
require("mini.bufremove").setup({})
require("mini.comment").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.jump").setup({})
require("mini.surround").setup({})
require("mini.tabline").setup({})
require("nvim-tree").setup()

require("neotest").setup({
  adapters = {
    require("neotest-go"),
    require("neotest-java")({
        -- ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
        -- project_type = "gradle",
    }),
    require("neotest-jest"),
    require("neotest-python"),
  }
})

local opts = { noremap = true, silent = true, buffer = false }
vim.keymap.set("n", "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", opts)
vim.keymap.set("n", "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", opts)
vim.keymap.set("n", "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", opts)
vim.keymap.set("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", opts)
vim.keymap.set("n", "<leader>tA", "<cmd>lua require('neotest').run.run({suite=true})<cr>", opts)
vim.keymap.set("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", opts)
vim.keymap.set("n", "<leader>to", "<cmd>lua require('neotest').output.open({enter=true})<cr>", opts)


-- ===========================================
-- ====== nvim-treesitter configuration ======
-- ===========================================
require("nvim-treesitter.configs").setup({
    ensure_installed = { "python", "vim", "lua", "javascript", "go", "json", "typescript" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})

-- ===========================================
-- ========== lualine configuration ==========
-- ===========================================

require("lualine").setup({
    options = {
        icons_enabled = true,
        -- component_separators = '|',
        -- section_separators = '',
    },
    sections = {
        lualine_c = { "filename", require('lsp-conf').active },
    },
    extensions = { "quickfix", "man", "nvim-dap-ui" }
})


vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
