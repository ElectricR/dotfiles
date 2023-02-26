return {
    {
        "machakann/vim-sandwich",
        keys = {
            { Keys.sandwich.add, "<Plug>(operator-sandwich-add)", mode = {'n', 'v'}, noremap = true, silent = true},
            { Keys.sandwich.delete, "<Plug>(operator-sandwich-delete)", mode = {'n', 'v'}, noremap = true, silent = true},
            { Keys.sandwich.replace, "<Plug>(operator-sandwich-replace)", mode = {'n', 'v'}, noremap = true, silent = true},
        },
        init = function ()
            vim.g.operator_sandwich_no_default_key_mappings = 1
        end,
    },
}
