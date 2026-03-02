local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

local insert_modes = { 'i', 's' }

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]

  return col ~= 0 and current_line:sub(col, col):match('%s') == nil
end

local common_source_order = {
  { name = 'nvim_lsp' },
  { name = 'luasnip' },
  { name = 'nvim_lua' },
  { name = 'buffer' },
  { name = 'path' },
}

cmp.setup({
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
      -- that way you will only jump inside the snippet region
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, insert_modes),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, insert_modes),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
    ['<C-j>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },

  sources = common_source_order,

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[API]",
        path = "[path]",
        luasnip = "[snip]",
      }
    }
  },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  experimental = {
    native_menu = false,
    ghost_text = true,
  },
})

-- Set configuration for specific filetype.
local git_commit_sources = {
  { name = 'buffer' },
}

local has_cmp_git, _ = pcall(require, 'cmp_git')
if has_cmp_git then
  table.insert(git_commit_sources, 1, { name = 'cmp_git' })
end

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources(git_commit_sources)
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
