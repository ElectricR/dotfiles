return {
    {
        "phaazon/hop.nvim",
        opts = {
            keys = 'qvwkldircjmpasonetuh',
        },
        keys = {
            { Keys.hop.line, function() require('hop').hint_lines_skip_whitespace() end, mode = {'n', 'v'}, noremap = true, silent = true },
            { Keys.hop.char2, function() require('hop').hint_char2() end, mode = {'n', 'v'}, noremap = true, silent = true },
            { Keys.hop.word, function() require('hop').hint_words() end, mode = {'n', 'v'}, noremap = true, silent = true },
        }
    },
}
