-- remape leader to <space>
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<leader>b', '<cmd>b#<CR>', { desc = 'Switch to Other Buffer' })

-- Show line and relative numbers
vim.opt.number = true

-- copy to system clipboard, even in tmux and ssh
vim.g.clipboard = 'osc52'

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Save undo history
vim.opt.undofile = true

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Indenting and tabbing
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = { style = "night"},
    },
    { 
      "catppuccin/nvim", 
      name = "catppuccin", 
      priority = 1000,
    },
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      -- or if using mini.icons/mini.nvim
      -- dependencies = { "echasnovski/mini.icons" },
      opts = {}
    },
    {
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { -- requires fzf to be installed
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make',
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
      },
      config = function()
        require('telescope').setup({})

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Find Files (Root Dir)' })
        vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Grep (Root Dir)' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
      end,
    },
    {
      'mfussenegger/nvim-lint',
      events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
      config = function()
        local lint = require('lint')

        -- NOTE: Linting for JS/TS is provided by `eslint` lsp server
        lint.linters_by_ft = {
          python = { 'flake8' },
        }

        local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
          group = lint_augroup,
          callback = function()
            lint.try_lint()
          end,
        })

        vim.keymap.set('n', '<leader>cl', function()
          lint.try_lint()
        end, { desc = 'Lint' })
      end,
    },
    {
      'stevearc/conform.nvim',

      event = { 'BufReadPre', 'BufNewFile' },
      cmd = { 'ConformInfo' },
      keys = {
        {
          '<leader>cf',
          function()
            require('conform').format({ async = false, lsp_format = 'fallback' })
          end,
          mode = { 'n', 'v' },
          desc = 'Format',
        },
      },
      opts = {
        format_on_save = {
          timeout_ms = 3000,
          lsp_format = 'fallback',
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'isort', 'black' },
          -- We use eslint_d to process fixable problems on save
          javascript = { 'eslint_d', 'prettierd' },
          typescript = { 'eslint_d', 'prettierd' },
          javascriptreact = { 'eslint_d', 'prettierd' },
          typescriptreact = { 'eslint_d', 'prettierd' },
          css = { 'eslint_d', 'prettierd' },
          html = { 'eslint_d', 'prettierd' },
          json = { 'eslint_d', 'prettierd' },
          yaml = { 'eslint_d', 'prettierd' },
        },
      },
    },
  },
  { 'nvim-lua/plenary.nvim', lazy = true },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "tokyonight" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require('fzf-lua').setup({
  -- Specify the exact path to the fzf executable
  fzf_bin = vim.fn.expand('~/.fzf/bin/fzf'),
})
vim.cmd('FzfLua setup_fzfvim_cmds')

vim.keymap.set('n', '<leader>f', ':Files<cr>', { noremap = true, silent = true})

local function toggle_quickfix()
  local windows = vim.fn.getwininfo()
  for _, win in pairs(windows) do
    if win["quickfix"] == 1 then
      vim.cmd.lclose()
      return
    end
  end
  vim.diagnostic.setloclist()
end
vim.keymap.set('n', '<Leader>l', toggle_quickfix, { desc = "Toggle Quickfix Window" })
vim.keymap.set('n', '<Leader>k', vim.diagnostic.open_float, { desc = "Toggle Current Line Float" })

vim.cmd.colorscheme('catppuccin')
