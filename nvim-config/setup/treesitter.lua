local ts_configs_ok, ts_configs = pcall(require, 'nvim-treesitter.configs')

local base_treesitter_config = {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

if ts_configs_ok then
  ts_configs.setup(base_treesitter_config)
else
  require('nvim-treesitter').setup(base_treesitter_config)
end

vim.opt.syntax = 'on'

local treesitter_compat_group = vim.api.nvim_create_augroup('TreesitterCompat', { clear = true })
vim.api.nvim_create_autocmd({'BufReadPost', 'BufNewFile'}, {
  group = treesitter_compat_group,
  callback = function(ev)
    local has_parser = pcall(vim.treesitter.get_parser, ev.buf)
    if has_parser then
      pcall(vim.treesitter.start, ev.buf)
    end
  end,
})
