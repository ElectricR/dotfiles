return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        keys = {
            { Keys.sandwich.add, "<Plug>(operator-sandwich-add)", mode = {'n', 'v'}, noremap = true, silent = true},
        },
        init = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {"python", "cpp", "go", "lua", "rust", "sql"},
                sync_install = false,
                highlight = {
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                textobjects = {
                    select = {
                        enable = true,
                        -- Automatically jump forward to textobj
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            [Keys.treesitter.textobj.outer.func] = "@function.outer",
                            [Keys.treesitter.textobj.inner.func] = "@function.inner",
                            [Keys.treesitter.textobj.outer.class] = "@class.outer",
                            [Keys.treesitter.textobj.inner.class] = "@class.inner",
                            [Keys.treesitter.textobj.outer.param] = "@parameter.outer",
                            [Keys.treesitter.textobj.inner.param] = "@parameter.inner",
                            [Keys.treesitter.textobj.outer.loop] = "@loop.outer",
                            [Keys.treesitter.textobj.inner.loop] = "@loop.inner",
                            [Keys.treesitter.textobj.outer.cond] = "@conditional.outer",
                            [Keys.treesitter.textobj.inner.cond] = "@conditional.inner",
                        },
                        -- You can choose the select mode (default is charwise 'v')
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = 'V', -- linewise
                            ['@loop.outer'] = 'V', -- linewise
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            [Keys.treesitter.swap_next.func] = "@function.outer",
                            [Keys.treesitter.swap_next.class] = "@class.outer",
                            [Keys.treesitter.swap_next.param] = "@parameter.inner",
                        },
                        swap_previous = {
                            [Keys.treesitter.swap_prev.func] = "@function.outer",
                            [Keys.treesitter.swap_prev.class] = "@class.outer",
                            [Keys.treesitter.swap_prev.param] = "@parameter.inner",
                        },
                    },
                },
            } end,
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' }
}
