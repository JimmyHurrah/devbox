local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"
vim.opt.inccommand = "split"
vim.opt.wrap = false
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.scrolloff = 10
vim.opt.cmdheight = 1
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = "│ ", trail = "·", nbsp = "␣" }
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.hlsearch = true
vim.opt.winborder = "single"

-- Key mappings
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })
vim.keymap.set("x", "<leader>p", [[["_dP]], { desc = "Paste over Current Register" })

vim.keymap.set("x", "<leader>ce", ":CodeCompanion /explain<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "<leader>cf", ":CodeCompanion /fix<CR>", { noremap = true, silent = true })
vim.keymap.set(
	"x",
	"<leader>cr",
	":CodeCompanion /buffer Please refactor this code to improve readability and maintainability.<CR>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	"x",
	"<leader>co",
	":CodeCompanion /buffer Please optimize for improved performance.<CR>",
	{ noremap = true, silent = true }
)

-- Plugin set
require("lazy").setup({
	ui = {
		border = "rounded",
	},
	spec = {
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {
				style = "night",
				transparent = true,
				italics = {
					comments = true,
					keywords = true,
					functions = true,
					strings = true,
					variables = true,
				},
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			},
			init = function()
				vim.cmd("colorscheme tokyonight")
			end,
		},
		{
			"stevearc/oil.nvim",
			dependencies = { { "echasnovski/mini.icons", opts = {} } },
			lazy = false,
			keys = {
				{
					"<C-n>",
					function()
						if vim.bo.filetype == "oil" then
							vim.cmd("q")
						else
							vim.cmd("Oil --float")
						end
					end,
				},
			},
			opts = {
				default_file_explorer = true,
				view_options = {
					show_hidden = true,
				},
			},
		},
		{
			"alexghergh/nvim-tmux-navigation",
			opts = {
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			main = "nvim-treesitter.configs",
			opts = {
				auto_install = true,
				ensure_installed = {
					"comment",
					"css",
					"go",
					"html",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"toml",
					"yaml",
				},
				highlight = {
					enable = true,
				},
			},
		},
		{
			"ibhagwan/fzf-lua",
			dependencies = { "echasnovski/mini.icons" },
			opts = {
				{ "telescope" }, -- use telescope opts as base
				winopts = {
					preview = {
						hidden = "hidden",
					},
				},
			},
			keys = {
				{ "<leader>ff", "<cmd>FzfLua files<cr>" },
				{ "<leader>fo", "<cmd>FzfLua oldfiles<cr>" },
				{ "<leader>fg", "<cmd>FzfLua live_grep<cr>" },
				{ "<leader>fw", "<cmd>FzfLua grep_cword<cr>" },
				{ "<leader>fv", "<cmd>FzfLua grep_visual<cr>" },
				{ "<leader>ft", "<cmd>FzfLua tabs<cr>" },
			},
		},
		{
			"kdheepak/lazygit.nvim",
			lazy = true,
			cmd = {
				"LazyGit",
				"LazyGitConfig",
				"LazyGitCurrentFile",
				"LazyGitFilter",
				"LazyGitFilterCurrentFile",
			},
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			keys = {
				{ "<leader>gt", "<cmd>LazyGit<cr>", desc = "LazyGit" },
			},
		},
		{
			"github/copilot.vim",
			lazy = false,
			event = "InsertEnter",
			config = function()
				vim.g.copilot_no_tab_map = true
				vim.api.nvim_set_keymap(
					"i",
					"<C-l>",
					[[copilot#Accept("\<CR>")]],
					{ expr = true, silent = true, noremap = true }
				)
			end,
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			ft = { "markdown", "codecompanion" },
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				local util = require("lspconfig.util")

				vim.lsp.config("gopls", {
					cmd = { "gopls" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					root_dir = util.root_pattern("go.work, go.mod", ".git"),
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							analyses = {
								unusedparams = true,
							},
						},
					},
				})

				vim.lsp.config("lua_ls", {
					settings = {
						Lua = {
							telemetry = { enable = false },
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				})
				vim.lsp.enable("gopls")
				vim.lsp.enable("lua_ls")
			end,
		},
		{
			"stevearc/conform.nvim",
			opts = {
				async = true,
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt" },
					cs = { "csharpier" },
					csproj = { "csharpier" },
				},
				formatters = {
					csharpier = {
						command = "csharpier",
						args = { "format", "--write-stdout" },
					},
					to_stdin = true,
				},
			},
		},
		{
			"williamboman/mason.nvim",
			opts = {
				ensure_installed = {
					"gopls",
					"lua_ls",
					"csharpier",
				},
				ui = {
					border = "rounded",
				},
			},
		},
		{
			"saghen/blink.cmp",
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
			version = "*",
			opts = {
				sources = {
					per_filetype = {
						codecompanion = { "codecompanion" },
					},
				},
				cmdline = { enabled = false },
				keymap = { preset = "super-tab" },
				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},
			},
		},
		{
			"sphamba/smear-cursor.nvim",
			opts = {},
		},
		{
			"karb94/neoscroll.nvim",
			opts = {
				pre_hook = function()
					require("smear_cursor").enabled = false
				end,
				post_hook = function()
					require("smear_cursor").enabled = true
				end,
			},
		},
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			text = {
				spinner = "dots",
				done = "✔",
			},
		},
	},
	checker = { enabled = true },
})
require("fzf-lua").register_ui_select()

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
