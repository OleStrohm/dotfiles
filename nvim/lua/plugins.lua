local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim'
  use 'DrTom/fsharp-vim'

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
  -- use 'hrsh7th/cmp-nvim-lsp'
  -- use 'hrsh7th/cmp-nvim-lua'
  -- use 'hrsh7th/cmp-buffer'
  -- use 'hrsh7th/cmp-path'
  -- use 'hrsh7th/cmp-cmdline'
  -- use 'hrsh7th/nvim-cmp'
  use 'Saghen/blink.cmp'

  -- Snippets
  use 'L3MON4D3/LuaSnip'
  -- use 'saadparwaiz1/cmp_luasnip'

  use 'folke/neodev.nvim'
  
  -- Floaterms for development
  use 'voldikss/vim-floaterm'
  use 'numToStr/FTerm.nvim'

  use { "rcarriga/nvim-dap-ui", requires = { { "mfussenegger/nvim-dap" }, { "nvim-neotest/nvim-nio" } } }

  use 'TimUntersberger/neogit'

  use 'ggandor/lightspeed.nvim'
  
  use 'nvim-lualine/lualine.nvim'
  use 'dikiaap/minimalist'

  use 'j-hui/fidget.nvim'

  use 'IndianBoy42/tree-sitter-just'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
