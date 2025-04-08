
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.opt.swapfile = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.inccommand = 'split'
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.scrolloff = 10
vim.opt.cmdheight = 1
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.hlsearch = true

-- Key mappings
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction"})
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation"})
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration"})

-- Plugin setup
require("lazy").setup({
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
        }
      },
      init = function()
        vim.cmd("colorscheme tokyonight")
      end,
    },
    {
      'stevearc/oil.nvim',
      dependencies = { { "echasnovski/mini.icons", opts = {} } },
      lazy = false,
			keys = {
				{ '<C-n>', function()
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
          show_hidden = true
        }
      },
    },
    {
      'alexghergh/nvim-tmux-navigation',
      opts = {
        keybindings = {
          left = '<C-h>',
          down = '<C-j>',
          up = '<C-k>',
          right = '<C-l>',
        },
      },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      opts = {
        ensure_installed = {
          "lua",
          "go",
          "typescript",
          "javascript",
          "html",
          "css",
          "json",
          "yaml",
          "toml",
          "markdown",
          "markdown_inline"
        },
        auto_install = true,
      }
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
        { "<leader>gt", "<cmd>LazyGit<cr>", desc = "LazyGit" }
      },
    },
    {
      "github/copilot.vim",
      lazy = false,
      event = "InsertEnter",
      config = function()
        vim.g.copilot_no_tab_map = true
        vim.api.nvim_set_keymap("i", "<C-l>", [[copilot#Accept("\<CR>")]], { expr = true, silent = true, noremap = true })
      end,
    },
    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
        },
      },
      keys = {
        { "<leader>cc", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Action Palette" },
      },
    },
    {
      "williamboman/mason.nvim",
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("mason").setup({
          registries = {
            'github:mason-org/mason-registry',
            'github:crashdummyy/mason-registry',
          },
        })
        require("mason-lspconfig").setup()
        local lspconf = require("lspconfig")
        lspconf.gopls.setup({})
        lspconf.dockerls.setup({})
        lspconf.html.setup({})
        lspconf.lua_ls.setup({
          settings = {
            Lua = {
              telemetry = { enable = false },
              diagnostics = {
                globals = { "vim" },
              },
            }
          }
        })
      end,
    },
    {
      "saghen/blink.cmp",
      dependencies = {
        "rafamadriz/friendly-snippets",
      },
      version = '*',
      opts = {
        sources = {
          per_filetype = {
            codecompanion = { "codecompanion" },
          }
        },
        cmdline = { enabled = false, },
        keymap = { preset = 'super-tab' },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono'
        },
      },
    },
  },
  checker = { enabled = true },
})
require('fzf-lua').register_ui_select()
