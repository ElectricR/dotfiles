require('packer').startup(function(use)
    -- Don't forget to run PackerCompile after a change

    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP

    -- Completion stuff
    use 'hrsh7th/nvim-cmp' -- Core plugin
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-emoji'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'ray-x/cmp-treesitter'
    use 'hrsh7th/cmp-nvim-lua'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    -- Style
    use 'norcalli/nvim-colorizer.lua'
    use 'onsails/lspkind.nvim'
    use {
        "folke/twilight.nvim",
        config = function() require("twilight").setup {} end
    }

    -- Toggle line number behavior when window gets out of focus
    use 'jeffkreeftmeijer/vim-numbertoggle'

    -- Snippet
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use "rafamadriz/friendly-snippets"

    -- Telescope stuff
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'
    use 'kyazdani42/nvim-web-devicons'

    -- Misc
    use 'machakann/vim-sandwich'
    use {
        'phaazon/hop.nvim',
        branch = 'v2',
    }
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    use {
       "glepnir/lspsaga.nvim",
        branch = "main",
    } 
end)

require("completion")
require("treesitter")
require("nvim-colorizer")
require("sandwich")
require("nvim-hop")
require("nvim-lspsaga")
require("nvim-telescope")
