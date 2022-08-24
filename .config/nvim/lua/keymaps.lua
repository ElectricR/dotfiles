local keys = {}

local default_opts = {noremap = true, silent = true}

-- Diagnostics mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)


-- LSP mappings
keys.lsp_on_attach_mappings = function(bufnr)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  --vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  --vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  --vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --vim.keymap.set('n', '<leader>wl', function()
  --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --end, bufopts)
  --vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  --vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  --vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  --vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
end



-- Telescope bindings
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, default_opts)
vim.keymap.set('n', '<C-f>', require('telescope.builtin').live_grep, default_opts)
--vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, default_opts)
--vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, default_opts)

-- Sandwich bindings
vim.keymap.set({'n', 'v'}, '<leader>sa', '<Plug>(operator-sandwich-add)', default_opts)
vim.keymap.set({'n', 'v'}, '<leader>sd', '<Plug>(operator-sandwich-delete)', default_opts)
vim.keymap.set({'n', 'v'}, '<leader>sr', '<Plug>(operator-sandwich-replace)', default_opts)

return keys
