return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim'

  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-ui-select.nvim'

  use 'dstein64/vim-startuptime'
  use 'nathom/filetype.nvim'

  -- nvim-lsp
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'

  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp_extensions.nvim'
  
  -- Completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- Snippets
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  
  -- Floaterms for development
  use 'voldikss/vim-floaterm'

  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

  use 'TimUntersberger/neogit'
  
  use 'nvim-lualine/lualine.nvim'
  use 'dikiaap/minimalist'
end)
