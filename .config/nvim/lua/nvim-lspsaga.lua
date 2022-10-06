require("lspsaga").init_lsp_saga {
    border_style = "rounded",
    code_action_lightbulb = {
        sign = false,
    },
    definition_action_keys = {
        edit = '<C-o>',
        tabe = '<C-t>',
        vsplit = '<kRight>',
        split = '<kLeft>',
        quit = '<C-c>',
    },
    finder_action_keys = {
        tabe = '<C-t>',
        quit = '<C-c>',
    },
    code_action_keys = {
        quit = "<C-c>",
    },
    symbol_in_winbar = {
        enable = false,
    },
}
