local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function fzf_multi_select(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = table.getn(picker:get_multi_selection())

    if num_selections > 1 then
        for _, entry in ipairs(picker:get_multi_selection()) do
            vim.cmd(string.format("%s %s", ":tabe", entry.value))
        end
        vim.cmd('stopinsert')
    else
        actions.file_tab(prompt_bufnr)
    end
end

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        [keys.telescope.which_key] = "which_key",
        [keys.telescope.tab] = fzf_multi_select
      },
      n = {
        [keys.telescope.which_key] = "which_key",
        [keys.telescope.tab] = fzf_multi_select
      }
    }
  },
}
