local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")

local current_dir = debug.getinfo(1).source:match("@?(.*/)")
package.path = current_dir .. "?.lua;" .. package.path

local git_command = require('git_command')

---- git command
local function defaultMapping(map)
  map('i', '<CR>', function(prompt_bufnr)
    local selection = actions_state.get_selected_entry()
    actions.close(prompt_bufnr)
    vim.cmd(selection.value)
  end)

  map('n', '<CR>', function(prompt_bufnr)
    local selection = actions_state.get_selected_entry()
    actions.close(prompt_bufnr)
    if (type(selection.value) == "function") then
      selection.value()
    else
      vim.cmd(selection.value)
    end
  end)
end

local function git_command_show()
  return git_command.showPopup(defaultMapping)
end

-- command picker
local function command_picker()
  local commands = {
    { display = 'Git', cmd = git_command_show },
  }

  pickers.new({}, {
    prompt_title = 'Commands Popup',
    finder = finders.new_table {
      results = commands,
      entry_maker = function(entry)
        return {
          value = entry.cmd,
          display = entry.display,
          ordinal = entry.display
        }
      end
    },
    sorter = sorters.get_generic_fuzzy_sorter(),
    attach_mappings = function(_, map)
      defaultMapping(map)

      map('n', '<leader>g', git_command_show, { silent = true, nowait = true })

      return true
    end
  }):find()
end

vim.keymap.set('n', '<leader>s', command_picker, { silent = true })
vim.keymap.set('n', 'sg', git_command_show, { silent = true, nowait = true })
