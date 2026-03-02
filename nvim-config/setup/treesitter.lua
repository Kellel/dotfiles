require('nvim-treesitter').setup()

vim.api.nvim_create_augroup('treesitter-config', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'treesitter-config',
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})
