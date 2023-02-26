return {
    { "nvim-telescope/telescope-fzy-native.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { Keys.telescope.grep, function() require("telescope.builtin").live_grep() end, mode = 'n', noremap = true, silent = true},
            { Keys.telescope.files, function() require("telescope.builtin").find_files() end, mode = 'n', noremap = true, silent = true},
            { Keys.telescope.buffers, function() require("telescope.builtin").buffers() end, mode = 'n', noremap = true, silent = true},
            { Keys.telescope.help, function() require("telescope.builtin").help_tags() end, mode = 'n', noremap = true, silent = true},
            { Keys.telescope.registers, function() require("telescope.builtin").registers() end, mode = 'n', noremap = true, silent = true},
            { Keys.telescope.treesitter, function() require("telescope.builtin").treesitter() end, mode = 'n', noremap = true, silent = true},
        },
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
}
