---- vim setup ----
-- setup relative line nums
vim.opt.number = true
vim.opt.relativenumber = true

-- set up real tabs
vim.opt.tabstop = 8 
vim.opt.shiftwidth = 8
vim.opt.expandtab = false
vim.opt.autoindent = true

-- make sure we have true color
vim.opt.termguicolors = true

-- set <leader> to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

---- lazy setup ----
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- setup lazy
require("lazy").setup({
	-- for better integration with tmux
	"christoomey/vim-tmux-navigator",

	-- for syntax highlighting
	"nvim-treesitter/nvim-treesitter",

	-- best theme ever
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},

	-- cool looking statusline
	"nvim-lualine/lualine.nvim",

	-- indent guides
	"lukas-reineke/indent-blankline.nvim",

	-- telescope for quick navigation
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.4',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},

	-- mason for lsp stuff
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"clangd"
			}
		},
	},

	-- lspconfigs
	"neovim/nvim-lspconfig",
	"williamboman/mason-lspconfig.nvim",

	-- formatting
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "VeryLazy",
	},

	-- file tabs
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons", -- for file iconds
		},
	},

	-- discord presence
	"andweeb/presence.nvim",

	-- wakatime
	"wakatime/vim-wakatime",

	-- coc.nvim
	{
		"neoclide/coc.nvim",
		branch = "release",
	},
})

-- setup treesitter
require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true,
	},
	ensure_installed = {
		"cpp",
		"lua",
		"python",
	}
})

-- enable catppuccin
vim.cmd 'colorscheme catppuccin'

-- setup lualine
require('lualine').setup()

-- setup indent-blankline
require('ibl').setup()

-- setup telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
require('telescope').setup()

-- setup mason
require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = { "clangd" }
})

-- clangd
require('lspconfig').clangd.setup({})

-- pyright (python lsp)
require('lspconfig').pyright.setup({})

-- null-ls
null_ls = require('null-ls')
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.clang_format,
	},

	-- format on save
	on_attach = function(client, buf)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = augroup,
				buffer = buf,
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = buf })
				end,
			})
		end
	end,
})
vim.keymap.set('n', '<leader>fn', vim.lsp.buf.format, {})

-- barbar
require('barbar').setup()
vim.keymap.set('n', '<tab>', '<cmd>BufferNext<CR>', {})
vim.keymap.set('n', '<s-tab>', '<cmd>BufferPrevious<CR>', {})
vim.keymap.set('n', '<space>x', '<cmd>BufferClose<CR>', {})

-- discord presence
require("presence").setup()
