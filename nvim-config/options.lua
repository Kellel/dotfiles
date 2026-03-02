-- THEME
vim.opt.background = 'dark'

-- QOL settings
local home = os.getenv("HOME")
vim.opt.backupdir = home .. '/.config/nvim/tmp/backup_files/'
vim.opt.directory = home .. '/.config/nvim/tmp/swap_files/'
vim.opt.undodir = home .. '/.config/nvim/tmp/undo_files/'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.scrolloff = 10
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.relativenumber = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.wrap = false
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.number = true
--vim.opt.colorcolumn = '100'

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.showmode = false

local box_border = 'rounded'

vim.opt.winborder = box_border

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ LSP Diagnostics ]]
vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = false,
  float = {
    border = box_border,
    source = 'if_many',
    focusable = false,
    close_events = { 'BufHidden', 'CursorMoved', 'CursorMovedI' },
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '☕',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    },
  },
})
-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 500
local diagnostic_float = vim.api.nvim_create_augroup('DiagnosticFloat', { clear = true })
vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      border = box_border,
      focusable = false,
    })
  end,
  group = diagnostic_float,
  pattern = '*',
})
