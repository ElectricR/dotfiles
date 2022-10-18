require("lspsaga").init_lsp_saga {
    border_style = "rounded",
    code_action_lightbulb = {
        sign = false,
    },
    definition_action_keys = {
        edit = keys.lspsaga.edit,
        tabe = keys.lspsaga.tabe,
        vsplit = keys.lspsaga.vsplit,
        split = keys.lspsaga.split,
        quit = keys.lspsaga.quit,
    },
    finder_action_keys = {
        tabe = keys.lspsaga.tabe,
        quit = keys.lspsaga.quit,
    },
    code_action_keys = {
        quit = keys.lspsaga.quit,
    },
    symbol_in_winbar = {
        enable = false,
    },
    finder_request_timeout = 7500,
}
