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

vim.keymap.set('n', '<leader>lg', execute_if_available('LazyGit'), { noremap = true, silent = true })

-- lsp trouble
vim.keymap.set('n', '<leader>tt', execute_if_available('TroubleToggle document_diagnostics', 'Trouble plugin is not installed'), { noremap = true })
vim.keymap.set('n', '<leader>tw', execute_if_available('TroubleToggle workspace_diagnostics', 'Trouble plugin is not installed'), { noremap = true })
vim.keymap.set('n', '<leader>tq', execute_if_available('TroubleToggle quickfix', 'Trouble plugin is not installed'), { noremap = true })
vim.keymap.set('n', '<leader>td', execute_if_available('TroubleToggle lsp_definitions', 'Trouble plugin is not installed'), { noremap = true })
vim.keymap.set('n', '<leader>tr', execute_if_available('TroubleToggle lsp_references', 'Trouble plugin is not installed'), { noremap = true })

-- telescope
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd>lua require('telescope.builtin').diagnostics()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fi', "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", { noremap = true })
vim.keymap.set('n', '<leader>fw', function()
  local ok = pcall(function()
    vim.cmd('Telescope telescope-cargo-workspace switch')
  end)

  if not ok then
    require('telescope.builtin').find_files()
  end
end, { noremap = true })

-- neotree
vim.keymap.set('n', '<leader><space>', "<cmd>Neotree<cr>", { noremap = true })
