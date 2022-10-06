require('monokai').setup { palette = require('monokai').soda }
-- Time that takes for CursorHold highlighting to appear
require("settings")
keys = require("keymaps")
require("plugins")
vim.api.nvim_create_autocmd({'BufWinEnter'}, {
    command = ':TwilightEnable',
})
