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
map('n', '<leader>tt', execute_if_available('TroubleToggle document_diagnostics', 'Trouble plugin is not installed'), 'Open document diagnostics in Trouble')
map('n', '<leader>tw', execute_if_available('TroubleToggle workspace_diagnostics', 'Trouble plugin is not installed'), 'Open workspace diagnostics in Trouble')
map('n', '<leader>tq', execute_if_available('TroubleToggle quickfix', 'Trouble plugin is not installed'), 'Open quickfix in Trouble')
map('n', '<leader>td', execute_if_available('TroubleToggle lsp_definitions', 'Trouble plugin is not installed'), 'Open definitions in Trouble')
map('n', '<leader>tr', execute_if_available('TroubleToggle lsp_references', 'Trouble plugin is not installed'), 'Open references in Trouble')

-- telescope
map('n', '<leader>ff', function()
  require('telescope.builtin').find_files()
end, 'Find files')
map('n', '<leader>fg', function()
  require('telescope.builtin').live_grep()
end, 'Live grep')
map('n', '<leader>fb', function()
  require('telescope.builtin').buffers()
end, 'Find buffers')
map('n', '<leader>fh', function()
  require('telescope.builtin').help_tags()
end, 'Search help')
map('n', '<leader>fd', function()
  require('telescope.builtin').diagnostics()
end, 'Search diagnostics')
map('n', '<leader>fi', function()
  require('telescope.builtin').lsp_implementations()
end, 'Find implementations')
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
