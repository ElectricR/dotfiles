require('monokai').setup { palette = require('monokai').soda }
vim.cmd('set updatetime=300')
vim.cmd('autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()')
vim.cmd('autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()')
vim.cmd('autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()')
require("settings")
keys = require("keymaps")
require("plugins")
