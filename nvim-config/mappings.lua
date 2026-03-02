-- lazygit
local function execute_if_available(command, fallback)
  local command_name = command:match('^([^%s]+)')
  return function()
    if vim.fn.exists(":" .. command_name) == 2 then
      vim.cmd(command)
    else
      vim.notify((fallback or (command_name .. " is not available")), vim.log.levels.WARN)
    end
  end
end

local function map(mode, lhs, rhs, desc, opts)
  local mapping_opts = {
    desc = desc,
    noremap = true,
    silent = true,
  }

  if opts then
    mapping_opts = vim.tbl_deep_extend('force', mapping_opts, opts)
  end

  vim.keymap.set(mode, lhs, rhs, mapping_opts)
end

map('n', '<leader>lg', execute_if_available('LazyGit'), 'Open LazyGit')

-- lsp trouble
local trouble_mappings = {
  { '<leader>tt', 'document_diagnostics', 'Open document diagnostics in Trouble' },
  { '<leader>tw', 'workspace_diagnostics', 'Open workspace diagnostics in Trouble' },
  { '<leader>tq', 'quickfix', 'Open quickfix in Trouble' },
  { '<leader>td', 'lsp_definitions', 'Open definitions in Trouble' },
  { '<leader>tr', 'lsp_references', 'Open references in Trouble' },
}

for _, mapping in ipairs(trouble_mappings) do
  map('n', mapping[1], execute_if_available('TroubleToggle ' .. mapping[2], 'Trouble plugin is not installed'), mapping[3])
end

-- telescope
local telescope_mappings = {
  { '<leader>ff', 'find_files', 'Find files' },
  { '<leader>fg', 'live_grep', 'Live grep' },
  { '<leader>fb', 'buffers', 'Find buffers' },
  { '<leader>fh', 'help_tags', 'Search help' },
  { '<leader>fd', 'diagnostics', 'Search diagnostics' },
  { '<leader>fi', 'lsp_implementations', 'Find implementations' },
}

for _, mapping in ipairs(telescope_mappings) do
  map('n', mapping[1], function()
    require('telescope.builtin')[mapping[2]]()
  end, mapping[3])
end
map('n', '<leader>fw', function()
  local ok = pcall(function()
    vim.cmd('Telescope telescope-cargo-workspace switch')
  end)

  if not ok then
    require('telescope.builtin').find_files()
  end
end, 'Switch cargo workspace or fallback to find files')

-- neotree
map('n', '<leader><space>', '<cmd>Neotree<cr>', 'Open Neo-tree')
