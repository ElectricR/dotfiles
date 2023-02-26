return {
    {
        "glepnir/lspsaga.nvim",
        config = function()
            require("lspsaga").setup({
                ui = {
                    border = "rounded",
                    title = false,
                },
                request_timeout = 7500,
                symbol_in_winbar = {
                    enable = false,
                },
                definition = {
                    edit = Keys.lspsaga.edit,
                    tabe = Keys.lspsaga.tabe,
                    vsplit = Keys.lspsaga.vsplit,
                    split = Keys.lspsaga.split,
                    quit = Keys.lspsaga.quit,
                },
                lightbulb = {
                    sign = false,
                },
                finder = {
                    tabe = Keys.lspsaga.tabe,
                    quit = Keys.lspsaga.quit,
                },
                code_action = {
                    keys = {
                        quit = Keys.lspsaga.quit,
                    }
                },
            })
        end,
        dependencies = {
            {"nvim-tree/nvim-web-devicons"},
            {"nvim-treesitter/nvim-treesitter"},
        },
    }
}
