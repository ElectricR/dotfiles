return {
    { 'neovim/nvim-lspconfig' }, -- Configurations for Nvim LSP

    -- Completion stuff
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-emoji' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'ray-x/cmp-treesitter' },
    { 'hrsh7th/cmp-nvim-lua' },

    -- Snippet
    { 'L3MON4D3/LuaSnip' },
    { 'saadparwaiz1/cmp_luasnip' },
    { "rafamadriz/friendly-snippets" },

    -- Style
    { 'onsails/lspkind.nvim' },
    -- Core
    {
        'hrsh7th/nvim-cmp',
        init = function()
            local cmp = require("cmp")

            vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(_, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                -- WHAT IS THIS?
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                Keys.lsp_on_attach_mappings(bufnr)
            end

            require("luasnip.loaders.from_vscode").lazy_load()

            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    [Keys.cmp.scroll_docs_up] = cmp.mapping.scroll_docs(-4),
                    [Keys.cmp.scroll_docs_down] = cmp.mapping.scroll_docs(4),
                    [Keys.cmp.complete] = cmp.mapping.complete(), -- Trigger opening completion window
                    [Keys.cmp.abort] = cmp.mapping.abort(),
                    [Keys.cmp.confirm] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    [Keys.cmp.tab] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
                        end
                    end, { "i", "s" }),
                    [Keys.cmp.stab] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' },
                    { name = 'nvim_lua' },
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                    { name = 'treesitter' },
                    { name = 'emoji' },
                },
                {
                    { name = 'buffer' },
                }),
                formatting = {
                    format = require('lspkind').cmp_format {
                        mode = 'symbol_text', -- show only symbol annotations
                        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                        menu = ({
                            nvim_lsp_signature_help = "[Sign]",
                            buffer = "[Buf]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snip]",
                            nvim_lua = "[NLua]",
                            treesitter = "[Tree]",
                            path = "[Path]",
                            emoji = "[Emoji]",
                        }),
                    }
                },
                experimental = { ghost_text = true },
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = 'buffer' } }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
            require('lspconfig')['pyright'].setup{
                on_attach = on_attach,
                capabilities = capabilities,
                root_dir = require('lspconfig.util').root_pattern("ya.make", "go.work", "go.mod", ".git"),
            }
            require('lspconfig')['gopls'].setup {
                on_attach = on_attach,
                capabilities = capabilities,
                --root_dir = require('lspconfig.util').root_pattern("ya.make", "go.work", "go.mod", ".git"),
                root_dir = require('lspconfig.util').root_pattern("mdb-internal-api"),
                settings = {
                    gopls = {
                        expandWorkspaceToModule = false,
                        directoryFilters = {
                            "-library/python",
                            "-library/cpp",
                            "-contrib",
                            "+contrib/go",
                            "-sandbox",
                            "-kikimr/public/sdk/python",
                            "-ydb/public/sdk/python",
                            "+cloud/mdb/mdb-internal-api",
                            "+cloud/mdb/rdsync",
                        },
                    },
                },
            }
            require('lspconfig').rust_analyzer.setup{
                on_attach=on_attach,
                capabilities = capabilities,
            }
            require('lspconfig').lua_ls.setup {
                on_attach    = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {'vim'},
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }
            require('lspconfig').clangd.setup{}
        end
    },
}
