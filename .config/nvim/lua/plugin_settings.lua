-- Tree sitter {{{
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "rust" },
  highlight = { enable = true, },
  indent = { enable = true },
}

require("filetype").setup({
  overrides = {
    extensions = {
      scm = "query",
    },
  },
})

--- }}}
-- Completion {{{
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
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
-- Luasnips {{{
require'luasnip'.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

-- Rest of configuration is in after/plugin/luasnip.lua
-- }}}
-- LSP {{{
local nvim_lsp = require'lspconfig'

function TSRCA()
  local opts =  {}
  opts.params = vim.lsp.util.make_given_range_params()
  require('telescope.builtin').lsp_code_actions(opts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)
  -- lsp keymaps {{{
  function map(mode, shortcut, command, desc)
      vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true, desc = desc, buffer = 0 })
  end

  map('n', '<leader>f', vim.lsp.buf.formatting, "Format file")
  map('n', '<leader>rn', vim.lsp.buf.rename, "Rename symbol")

  map('n', 'gd', vim.lsp.buf.definition, "Go to the definition of symbol")
  map('n', 'gt', vim.lsp.buf.type_definition, "Go to the definition of the type of symbol")
  map('n', 'gD', vim.lsp.buf.declaration, "Go to the declaration of symbol")
  map('n', "gi", require('telescope.builtin').lsp_implementations, "List the implementations of symbol")
  map('n', "gr", require('telescope.builtin').lsp_references, "List the references of symbol")
  map('n', "ga", require('telescope.builtin').lsp_code_actions, "List code actions for the current location")
  map('v', "ga", ":<c-u>lua TSRCA()<cr>", "List code actions for the current selection")

  map('n', 'K', vim.lsp.buf.hover, "Show documentation of symbol")
  map('n', "<leader>o", require('telescope.builtin').lsp_document_symbols, "List all symbols in document")

  map('n', 'g[', vim.diagnostic.goto_prev, "Go to next diagnostic")
  map('n', 'g]', vim.diagnostic.goto_next, "Go to previous diagnostic")
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

--- }}}
-- Nvim-dap {{{
local dap = require('dap')

local extension_path = vim.fn.expand "~/.vscode-extensions/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

dap.adapters.rt_lldb = function(callback, _)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port
  local error_message = ""

  local opts = {
    stdio = { nil, stdout, stderr },
    args = { "--liblldb", liblldb_path },
    detached = true,
  }

  handle, pid_or_err = vim.loop.spawn(codelldb_path, opts, function(code)
    stdout:close()
    stderr:close()
    handle:close()
    if code ~= 0 then
      print("codelldb exited with code", code)
      print("error message", error_message)
    end
  end)

  assert(handle, "Error running codelldb: " .. tostring(pid_or_err))

  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      if not port then
        local chunks = {}
        for substring in chunk:gmatch "%S+" do
          table.insert(chunks, substring)
        end
        port = tonumber(chunks[#chunks])
        vim.schedule(function()
          callback {
            type = "server",
            host = "127.0.0.1",
            port = port,
          }
        end)
      else
        vim.schedule(function()
          require("dap.repl").append(chunk)
        end)
      end
    end
  end)
  stderr:read_start(function(_, chunk)
    if chunk then
      error_message = error_message .. chunk

      vim.schedule(function()
        require("dap.repl").append(chunk)
      end)
    end
  end)
end

dap.configurations.rust = {
  {
    name = "Launch",
    type = "rt_lldb",
    request = "launch",
    program = function()
      return vim.fn.getcwd() .. '/target/debug/forthlike'
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  }
}

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})
-- }}}
-- Telescope {{{
require('telescope').setup{}
function nnoremap(shortcut, command)
    vim.api.nvim_set_keymap("n", shortcut, command, { noremap = true, silent = true })
end
nnoremap("<leader>p", "<cmd>lua require('telescope.builtin').git_files()<cr>")

--- }}}
-- Lualine {{{
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = false,
    globalstatus = true,
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

--- }}}
-- Colorscheme {{{
vim.cmd([[
  colorscheme minimalist
  highlight WinSeparator ctermfg=Grey ctermbg=none
]])
--- }}}
