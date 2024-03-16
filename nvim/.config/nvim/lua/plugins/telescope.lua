return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  opts = {
    defaults = {
      layout_strategy = "vertical",
      layout_config = {
        height = 0.95,
        prompt_position = "top",
        vertical = {
          mirror = true,
          preview_cutoff = 40,
        },
      },
    },
  },
  config = function(_, opts)
    pcall(require("telescope").load_extension, "fzf")
    require("telescope").setup(opts)
  end,
    -- stylua: ignore
		keys = {
			{ '<leader>?',       function() require('telescope.builtin').oldfiles() end, desc = '[?] Find recently opened files' },
			{ '<leader><space>', function() require('telescope.builtin').buffers() end,  desc = '[ ] Find existing buffers' },
			{
				'<leader>/',
				function()
					require('telescope.builtin').current_buffer_fuzzy_find(require(
						'telescope.themes').get_dropdown {
						winblend = 10,
						previewer = false,
					})
				end,
				desc = '[/] Fuzzily search in current buffer'
			},
			{ '<leader>gf', function() require('telescope.builtin').git_files() end,   desc = 'Search [G]it [F]iles' },
			{ '<c-p>',      function() require('telescope.builtin').find_files() end,  desc = '[S]earch [F]iles' },
			{ '<leader>sh', function() require('telescope.builtin').help_tags() end,   desc = '[S]earch [H]elp' },
			{ '<leader>sw', function() require('telescope.builtin').grep_string() end, desc = '[S]earch current [W]ord' },
			{ '<leader>sg', function() require('telescope.builtin').live_grep() end,   desc = '[S]earch by [G]rep' },
			{ '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics' },
			{ '<leader>sr', function() require('telescope.builtin').resume() end,      desc = '[S]earch [R]esume' },
			-- { '<leader>sG', function() live_grep_git_root() end,                       desc = '[S]earch by [G]rep on Git Root' },
		},
}
