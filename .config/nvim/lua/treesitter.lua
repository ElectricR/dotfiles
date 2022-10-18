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
        [keys.treesitter.textobj.outer.func] = "@function.outer",
        [keys.treesitter.textobj.inner.func] = "@function.inner",
        [keys.treesitter.textobj.outer.class] = "@class.outer",
        [keys.treesitter.textobj.inner.class] = "@class.inner",
        [keys.treesitter.textobj.outer.param] = "@parameter.outer",
        [keys.treesitter.textobj.inner.param] = "@parameter.inner",
        [keys.treesitter.textobj.outer.loop] = "@loop.outer",
        [keys.treesitter.textobj.inner.loop] = "@loop.inner",
        [keys.treesitter.textobj.outer.cond] = "@conditional.outer",
        [keys.treesitter.textobj.inner.cond] = "@conditional.inner",
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
        [keys.treesitter.swap_next.func] = "@function.outer",
        [keys.treesitter.swap_next.class] = "@class.outer",
        [keys.treesitter.swap_next.param] = "@parameter.inner",
      },
      swap_previous = {
        [keys.treesitter.swap_prev.func] = "@function.outer",
        [keys.treesitter.swap_prev.class] = "@class.outer",
        [keys.treesitter.swap_prev.param] = "@parameter.inner",
      },
    },
  },
}
