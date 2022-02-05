require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "rust" },
  highlight = { enable = true, },
  indent = { enable = true },
}

-- Set up nvim-cmp {{{
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'ultisnips' }, -- For ultisnips users.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
-- }}}

local nvim_lsp = require'lspconfig'

function TSRCA()
  local opts =  {}
  opts.params = vim.lsp.util.make_given_range_params()
  require('telescope.builtin').lsp_code_actions(opts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)
-- lsp keymaps {{{
    function nnoremap(shortcut, command)
        vim.api.nvim_buf_set_keymap(bufnr, "n", shortcut, command, { noremap = true, silent = true })
    end
    function vnoremap(shortcut, command)
        vim.api.nvim_buf_set_keymap(bufnr, "v", shortcut, command, { noremap = true, silent = true })
    end

	nnoremap('<leader>f', '<cmd>lua vim.lsp.buf.formatting()<cr>')
	nnoremap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')

	nnoremap('gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
	nnoremap('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    nnoremap("ga", "<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>")
    -- vnoremap("ga", "<esc><cmd>'<,'>+1Telescope lsp_range_code_actions<cr>")
    vnoremap("ga", "<esc><cmd>lua TSRCA()<cr>")
	nnoremap('K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    nnoremap("gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>")
    nnoremap("gr", "<cmd>lua require('telescope.builtin').lsp_references()<cr>")
    nnoremap("<leader>o", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>")

	nnoremap('g[', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>')
	nnoremap('g]', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>')
-- }}}
end

nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

require('telescope').setup{}
function nnoremap(shortcut, command)
    vim.api.nvim_set_keymap("n", shortcut, command, { noremap = true, silent = true })
end
nnoremap("<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap("<leader>p", "<cmd>lua require('telescope.builtin').git_files()<cr>")

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {},
        always_divide_middle = false,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {
            {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                sections = { 'error', 'warn' },
                symbols = {error = 'E', warn = 'W' }
            }
        },
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}

vim.cmd([[
    colorscheme minimalist
    " autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
    "             \ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
]])
