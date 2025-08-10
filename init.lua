vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.clipboard = "unnamedplus"

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "mason-org/mason.nvim", opts = "", },
    },
    opts = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local servers = {
        "clangd",
        "eslint",
        "gopls",
        "lua_ls",
        "ols",
        "ocamllsp",
        "pyright",
        "rust_analyzer",
        "svelte",
        "vtsls",
        "tailwindcss",
        "zls",
      }
      return {
        automatic_installation = true,
        ensure_installed = servers,
        handlers = function(server)
          require("lspconfig")[server].setup({ capabilities = capabilities })
        end
      }
    end,
  },

  {
    "stevearc/conform.nvim",
    lazy = false,
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        glsl = { "clang_format" },
        go = { "gofmt", "goimports" },
        javascript = { "prettierd" },
        odin = { "odinfmt" },
        python = { "black" },
        rust = { "rustfmt" },
        svelte = { "prettierd" },
        typescript = { "prettierd" },
        zig = { "zigfmt" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      },
    },
  },

  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "enter",
      }
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      set_default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      toggler = {
        line = "<leader>/",
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {},
  },

  {
    "tpope/vim-sleuth",
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },


  {
    "benomahony/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = {},
  },

  {
    "goolord/alpha-nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("alpha").setup(require("alpha.themes.theta").config)
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("tokyonight-night")
    end
  },
})

local function map(mode, keys, cmd, desc)
  vim.keymap.set(mode, keys, cmd, { desc = desc, silent = true })
end

map('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
map('n', 'gr', vim.lsp.buf.references, '[G]oto [R]eferences')
map('n', 'gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
map('n', 'gt', vim.lsp.buf.type_definition, '[G]oto [T]ype Definition')
map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
map('n', '<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbol')
map('n', '<leader>D', vim.lsp.buf.declaration, '[D]eclaration')
map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
map('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

map('n', '[d', vim.diagnostic.goto_prev, 'Previous [D]iagnostic')
map('n', ']d', vim.diagnostic.goto_next, 'Next [D]iagnostic')
map('n', '<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

map('n', '<leader>fm', function() vim.lsp.buf.format { async = true } end, '[F]ormat')

local tb = require('telescope.builtin')
map('n', '<leader>ff', tb.find_files, '[F]ind [F]iles')
map('n', '<leader>fg', tb.live_grep, '[F]ind [G]rep')
map('n', '<leader>fb', tb.buffers, '[F]ind [B]uffers')
map('n', '<leader>fh', tb.help_tags, '[F]ind [H]elp')
map('n', '<leader>fn', function() tb.find_files({ cwd = vim.fn.stdpath('config') }) end, '[F]ind [N]eovim files')

map('n', '-', '<CMD>Oil<CR>', 'Open parent directory')

map('n', '<leader>td', '<cmd>TodoQuickfix<CR>', '[T]o[d]o Quickfix')
