return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

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
    
    -- Completion snippets
    use 'SirVer/ultisnips'
    use 'quangnguyen30192/cmp-nvim-ultisnips'
    
    -- extra highlighting
    use 'CaffeineViking/vim-glsl'
    use 'ap/vim-css-color'
    use 'cespare/vim-toml'
    use 'plasticboy/vim-markdown'
    
    use 'voldikss/vim-floaterm'

    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim' } }
    }
    
    use 'nvim-lualine/lualine.nvim'
    use 'dikiaap/minimalist'
end)
