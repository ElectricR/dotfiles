return {
    {
        "phaazon/hop.nvim",
        opts = {
            keys = 'hutenosapmjcridlkwvq',
        },
        keys = {
            { Keys.hop.forward_til, function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, mode = 'n', noremap = true, silent = true },
            { Keys.hop.forward_on, function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = true }) end, mode = 'n', noremap = true, silent = true },
            { Keys.hop.back_til, function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }) end, mode = 'n', noremap = true, silent = true },
            { Keys.hop.back_on, function() require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR, current_line_only = true }) end, mode = 'n', noremap = true, silent = true },
            { Keys.hop.line, function() require('hop').hint_lines_skip_whitespace() end, mode = {'n', 'v'}, noremap = true, silent = true },
            { Keys.hop.char2, function() require('hop').hint_char2() end, mode = {'n', 'v'}, noremap = true, silent = true },
            { Keys.hop.word, function() require('hop').hint_words() end, mode = {'n', 'v'}, noremap = true, silent = true },
        }
    },
}
