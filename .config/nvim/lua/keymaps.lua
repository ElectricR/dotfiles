local keys = {}

keys.lspsaga = {
    quit = '<C-c>',
    edit = '<C-e>',
    tabe = '<C-t>',
    vsplit = '<kRight>',
    split = '<kLeft>',
}

keys.cmp = {
    scroll_docs_down = '<C-b>',
    scroll_docs_up = '<C-f>',
    complete = '<C-Space>',
    abort = '<C-c>',
    confirm = '<CR>',
    tab = '<Tab>',
    stab = '<S-Tab>',
}

keys.treesitter = {
    textobj = {
        inner = {
            func = "if",
            class = "ic",
            param = "ia",
            loop = "il",
            cond = "iq",
        },
        outer = {
            func = "af",
            class = "ac",
            param = "aa",
            loop = "al",
            cond = "aq",
        }
    },
    swap_next = {
        func = '<leader>mf',
        class = '<leader>mc',
        param = '<leader>ma',
    },
    swap_prev = {
        func = '<leader>mF',
        class = '<leader>mC',
        param = '<leader>mA',
    },
}

keys.telescope = {
    which_key = '<C-h>',
    tab = '<C-t>',
}

local default_opts = {noremap = true, silent = true}

vim.keymap.set('n', '<leader>t', '<cmd>Twilight<CR>')

vim.keymap.set('n', 'g]', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n', 'g[', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)


-- LSP mappings
keys.lsp_on_attach_mappings = function(bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', '<cmd>Lspsaga peek_definition<CR>', bufopts)
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>gtd', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', bufopts)
    vim.keymap.set({'n', 'v'}, '<leader>ca', '<cmd>Lspsaga code_action<CR>', bufopts)
    --vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
    vim.keymap.set('n', '<leader>ga', '<cmd>Lspsaga lsp_finder<CR>', bufopts)
    vim.keymap.set('n', '<leader>dl', '<cmd>Lspsaga show_line_diagnostics<CR>', bufopts)
end


-- Telescope bindings
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, default_opts)
vim.keymap.set('n', '<C-f>', require('telescope.builtin').live_grep, default_opts)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, default_opts)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, default_opts)
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').registers, default_opts)
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').treesitter, default_opts)

-- Sandwich bindings
vim.keymap.set({'n', 'v'}, '<leader>sa', '<Plug>(operator-sandwich-add)', default_opts)
vim.keymap.set({'n', 'v'}, '<leader>sd', '<Plug>(operator-sandwich-delete)', default_opts)
vim.keymap.set({'n', 'v'}, '<leader>sr', '<Plug>(operator-sandwich-replace)', default_opts)


-- Hop bindings
vim.keymap.set('n', 'f', function()
    require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true })
end, default_opts)
vim.keymap.set('n', 'F', function()
    require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true })
end, default_opts)
vim.keymap.set('n', 't', function()
    require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, default_opts)
vim.keymap.set('n', 'T', function()
    require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, default_opts)
vim.keymap.set('', '<leader>hl', function()
    require('hop').hint_lines_skip_whitespace()
end, default_opts)
vim.keymap.set('', '<leader>hc', function()
    require('hop').hint_char2()
end, default_opts)
vim.keymap.set('', '<leader>hw', function()
    require('hop').hint_words()
end, default_opts)

return keys
