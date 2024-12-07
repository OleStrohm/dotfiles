-- Tree sitter {{{
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "rust" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "fsharp" },
  },
  indent = { enable = true },
}

require'tree-sitter-just'.setup{}
-- }}}
-- Filetype {{{
require("filetype").setup({
  overrides = {
    extensions = {
      scm = "query",
      fs = "fsharp",
    },
    literal = {
      justfile = "just",
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

-- }}}
-- Luasnips {{{
require'luasnip'.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

-- Rest of configuration is in after/plugin/luasnip.lua
-- }}}
-- LSP {{{
-- Set up neovim lua docs
local nvim_lsp = require'lspconfig'

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(--[[client, bufnr--]])
  -- lsp keymaps {{{
  local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc, buffer = 0 })
  end

  map('n', '<leader>f', vim.lsp.buf.format, "Format file")
  map('n', '<leader>rn', vim.lsp.buf.rename, "Rename symbol")

  map('n', 'gd', vim.lsp.buf.definition, "Go to the definition of symbol")
  map('n', 'gt', vim.lsp.buf.type_definition, "Go to the definition of the type of symbol")
  map('n', 'gD', vim.lsp.buf.declaration, "Go to the declaration of symbol")
  map('n', "gi", require('telescope.builtin').lsp_implementations, "List the implementations of symbol")
  map('n', "gr", require('telescope.builtin').lsp_references, "List the references of symbol")
  map('n', "ga", vim.lsp.buf.code_action, "List code actions for the current location")

  map('n', 'K', vim.lsp.buf.hover, "Show documentation of symbol")
  map('n', "<leader>o", require('telescope.builtin').lsp_document_symbols, "List all symbols in document")

  map('n', 'g[', vim.diagnostic.goto_prev, "Go to next diagnostic")
  map('n', 'g]', vim.diagnostic.goto_next, "Go to previous diagnostic")
  -- }}}
end

local function tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

local function merge_with_local(cfg)
  local project_specific_settings = loadfile(vim.fn.getcwd() .. '/lspconfig.lua')

  if project_specific_settings ~= nil then
    local local_cfg = project_specific_settings()

    return tableMerge(cfg, local_cfg)
  end

  return cfg
end

nvim_lsp.rust_analyzer.setup({
  on_attach=on_attach,
  capabilities = capabilities,
  settings = merge_with_local {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        features = "all",
      },
      check = {
        command = "clippy",
      },
      inlayHints = {
        enable = true,
      }
      -- This should be the default now
      --cargo = {
      --  loadOutDirsFromCheck = true
      --},
      --procMacro = {
      --  enable = true
      --},
    }
  },
  --cmd = { "/home/ole/src/rust-analyzer/target/debug/rust-analyzer" },
})

require("neodev").setup({})

nvim_lsp.lua_ls.setup({
  on_attach=on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})

nvim_lsp.fsautocomplete.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

--vim.api.nvim_create_autocmd("LspAttach", {
--  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--  callback = function(args)
--    local client = vim.lsp.get_client_by_id(args.data.client_id)
--    if client and client.server_capabilities.inlayHintProvider then
--      vim.lsp.inlay_hint.enable(args.buf, true)
--    end
--  end
--})

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
    if stdout then stdout:close() end
    if stderr then stderr:close() end
    if handle then handle:close() end
    if code ~= 0 then
      print("codelldb exited with code", code)
      print("error message", error_message)
    end
  end)

  assert(handle, "Error running codelldb: " .. tostring(pid_or_err))

  if stdout then
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
  end
  if stderr then
    stderr:read_start(function(_, chunk)
      if chunk then
        error_message = error_message .. chunk

        vim.schedule(function()
          require("dap.repl").append(chunk)
        end)
      end
    end)
  end
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
require('telescope').setup{
  --extensions = {
  --  ["ui-select"] = {
  --  }
  --}
}
local function nnoremap(shortcut, command)
    vim.api.nvim_set_keymap("n", shortcut, command, { noremap = true, silent = true })
end
nnoremap("<leader>p", "<cmd>lua require('telescope.builtin').git_files({ show_untracked = true })<cr>")
vim.keymap.set('n', '<leader>d', require('telescope.builtin').diagnostics, { desc = 'Show all diagnostics' })

require('telescope').load_extension("ui-select")

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
  highlight link LspInlayHint Comment
]])
--- }}}
-- Lightspeed {{{
vim.g.lightspeed_no_default_keymaps = true
require'lightspeed'.setup {}

vim.keymap.set("n", "s", "<Plug>Lightspeed_omni_s", { silent = true, noremap = true})
vim.keymap.set("n", "gs", "<Plug>Lightspeed_omni_gs", { silent = true, noremap = true})
-- }}}
-- Floaterm {{{
nnoremap("<leader>F", "<cmd>FloatermToggle!<cr>")
-- }}}
-- Figdet {{{
require'fidget'.setup{
  progress = {
    lsp = {
      progress_ringbuf_size = 1024
    },
  },
}
-- }}}
-- FTerm {{{
require'FTerm'.setup {
  dimensions = {
    height = 0.9,
    width = 0.9,
  },
}
-- }}}
