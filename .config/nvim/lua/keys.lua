Keys = {}

vim.keymap.set('v', '<leader>c', ":'<,'>!column -t -s= -o=<CR><CR>", {silent=true, noremap=true})

Keys.sandwich = {
    add = '<leader>sa',
    delete = '<leader>sd',
    replace = '<leader>sr',
}

Keys.hop = {
    forward_til = 't',
    forward_on = 'f',
    back_til = 'T',
    back_on = 'F',
    line = '<leader>hl',
    char2 = '<leader>hc',
    word = '<leader>hw',
}

Keys.telescope = {
    grep = '<C-f>',
    files = '<leader>ff',
    buffers = '<leader>fb',
    help = '<leader>fh',
    registers = '<leader>fr',
    treesitter = '<leader>ft',
}

Keys.treesitter = {
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

Keys.cmp = {
    scroll_docs_down = '<C-b>',
    scroll_docs_up = '<C-f>',
    complete = '<C-Space>',
    abort = '<C-c>',
    confirm = '<CR>',
    tab = '<Tab>',
    stab = '<S-Tab>',
}

Keys.lspsaga = {
    quit = '<C-c>',
    edit = '<C-e>',
    tabe = '<C-t>',
    vsplit = '<kRight>',
    split = '<kLeft>',
}

-- LSP mappings
Keys.lsp_on_attach_mappings = function(bufnr)
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

    vim.keymap.set('n', 'g]', '<cmd>Lspsaga diagnostic_jump_next<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', 'g[', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { noremap = true, silent = true })
end
