require('nvim-treesitter.configs').setup {
  ensure_installed = { "python", "lua", "go", "rust" },
  sync_install = false,
  highlight = {
    enable = true,
    disable = { "" },

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
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["aq"] = "@conditional.outer",
        ["iq"] = "@conditional.inner",
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
        ["<leader>mf"] = "@function.outer",
        ["<leader>mc"] = "@class.outer",
        ["<leader>ma"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>mF"] = "@function.outer",
        ["<leader>mC"] = "@class.outer",
        ["<leader>mA"] = "@parameter.inner",
      },
    },
  },
}
