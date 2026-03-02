local ts_configs_ok, ts_configs = pcall(require, 'nvim-treesitter.configs')

if ts_configs_ok then
  ts_configs.setup {
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  }
else
  require('nvim-treesitter').setup {
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  }
end
