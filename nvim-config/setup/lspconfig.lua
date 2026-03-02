local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local float_style = {
  border = 'rounded',
  max_width = 90,
  max_height = 30,
  focusable = false,
}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = float_style.border,
  max_width = float_style.max_width,
  max_height = float_style.max_height,
  focusable = float_style.focusable,
  close_events = { 'CursorMoved', 'BufHidden', 'InsertCharPre' },
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = float_style.border,
  focusable = float_style.focusable,
  close_events = { 'CursorMoved', 'BufHidden', 'InsertCharPre' },
})

local function code_action(opts)
  if vim.fn.exists(':CodeActionMenu') == 2 then
    vim.cmd('CodeActionMenu')
  else
    vim.lsp.buf.code_action(opts)
  end
end

local function rust_analyzer_cmd()
  local candidates = {
    vim.fn.expand('$CARGO_HOME/bin/rust-analyzer'),
    vim.fn.expand('~/.cargo/bin/rust-analyzer'),
  }

  for _, cmd in ipairs(candidates) do
    if cmd ~= nil and cmd ~= '' and vim.fn.executable(cmd) == 1 then
      return cmd
    end
  end

  if vim.fn.executable('rust-analyzer') == 1 then
    return 'rust-analyzer'
  end

  return nil
end

local function lsp_supports_method(client, method)
  if client == nil or type(client.supports_method) ~= 'function' then
    return false
  end

  local ok, supports = pcall(client.supports_method, client, method)
  return ok and supports or false
end

local function map_if_supported(buffer_opts, client, method, lhs, rhs, desc)
  if lsp_supports_method(client, method) then
    vim.keymap.set('n', lhs, rhs, vim.tbl_extend('force', buffer_opts, { desc = desc }))
  end
end

local LSP_KEYMAPS = {
  { 'textDocument/declaration', 'gD', vim.lsp.buf.declaration, 'LSP declaration' },
  { 'textDocument/definition', 'gd', vim.lsp.buf.definition, 'LSP definition' },
  { 'textDocument/hover', 'K', vim.lsp.buf.hover, 'LSP hover' },
  { 'textDocument/signatureHelp', '<C-k>', vim.lsp.buf.signature_help, 'LSP signature help' },
  { 'textDocument/implementation', 'gi', vim.lsp.buf.implementation, 'LSP implementation' },
  { 'textDocument/typeDefinition', '<leader>D', vim.lsp.buf.type_definition, 'LSP type definition' },
  { 'textDocument/rename', '<leader>rn', vim.lsp.buf.rename, 'LSP rename symbol' },
  { 'textDocument/references', 'gr', vim.lsp.buf.references, 'LSP references' },
}

local function format_if_supported(client, buffer_opts, desc)
  if lsp_supports_method(client, 'textDocument/formatting') or lsp_supports_method(client, 'textDocument/rangeFormatting') then
    vim.keymap.set('n', '<leader>fm', function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend('force', buffer_opts, { desc = desc }))
  end
end

local function on_attach(client, bufnr)
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  local opts = { buffer = bufnr }

  for _, mapping in ipairs(LSP_KEYMAPS) do
    map_if_supported(opts, client, mapping[1], mapping[2], mapping[3], mapping[4])
  end

  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', opts, { desc = 'Add workspace folder' }))
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', opts, { desc = 'Remove workspace folder' }))
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, vim.tbl_extend('force', opts, { desc = 'List workspace folders' }))
  vim.keymap.set('n', '<leader>ca', function()
    code_action({ apply = true })
  end, vim.tbl_extend('force', opts, { desc = 'LSP code action' }))

  format_if_supported(client, opts, 'Format buffer')
end

local function setup_server(name, opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend('force', {
    capabilities = capabilities,
    on_attach = on_attach,
  }, opts)

  lspconfig[name].setup(opts)
end

setup_server('clangd')
setup_server('cmake')
setup_server('dockerls')
setup_server('nil_ls')
setup_server('buf_ls')
setup_server('gopls')
setup_server('ansiblels')
setup_server('vimls')
setup_server('pyright', {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'off',
      },
    },
  },
})

local rust_opts = {}
local rust_cmd = rust_analyzer_cmd()
if rust_cmd ~= nil then
  rust_opts.cmd = { rust_cmd }
end
setup_server('rust_analyzer', rust_opts)

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostics float' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if lsp_supports_method(client, 'textDocument/documentHighlight') then
      local group = vim.api.nvim_create_augroup('LspDocumentHighlight' .. ev.buf, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight,
        group = group,
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
        group = group,
      })
    end
  end,
})
