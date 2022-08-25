require("completion")
require("treesitter")
require("rainbow")
require("nvim-colorizer")
require("sandwich")
require("nvim-hop")

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
    -- Don't forget to run PackerCompile after a change

    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP

    -- Completion stuff
    use 'hrsh7th/nvim-cmp' -- Core plugin
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lua'
    use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }

    -- Colorscheme
    use 'tanvirtin/nvim-monokai'

    use 'luochen1990/rainbow'
    use 'norcalli/nvim-colorizer.lua'

    -- Toggle line number behavior when window gets out of focus
    use 'jeffkreeftmeijer/vim-numbertoggle'

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

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)

