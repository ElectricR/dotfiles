require('monokai').setup { palette = require('monokai').soda }
require("settings")
ok, keys = pcall(require, "keymaps")
require("plugins")
