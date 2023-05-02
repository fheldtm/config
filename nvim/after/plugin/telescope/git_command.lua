local actions = require("telescope.actions")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local git_command = {}

function git_command.showPopup(defaultMapping)
  local commands = {
    { display = 'Git Diff',   cmd = 'Git diff' },
    { display = 'Git Blame',  cmd = 'Git blame' },
    { display = 'Git Commit', cmd = 'Git commit' }
  }

  pickers.new({}, {
    prompt_title = 'Git Commands',
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

      map('n', 'D', function(prompt_bufnr)
        os.execute('git diff')
        actions.close(prompt_bufnr)
      end)

      return true
    end
  }):find()
end

return git_command
