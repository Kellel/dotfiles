-- lazygit
vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>LazyGit<cr>', { noremap = true, silent = true })

-- lsp trouble
vim.api.nvim_set_keymap('n', '<leader>tt', '<cmd>TroubleToggle document_diagnostics<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tq', '<cmd>TroubleToggle quickfix<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>td', '<cmd>TroubleToggle lsp_definitions<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tr', '<cmd>TroubleToggle lsp_references<cr>', { noremap = true })

-- telescope
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd>lua require('telescope.builtin').diagnostics()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fi', "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fw', "<cmd>Telescope telescope-cargo-workspace switch<cr>", { noremap = true })

-- neotree
vim.api.nvim_set_keymap('n', '<leader><space>', "<cmd>Neotree<cr>", { noremap = true })
