local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require("telescope.actions")
local actions_state = require('telescope.actions.state')
local builtin = require("telescope.builtin")
local sorters = require("telescope.sorters")

local current_bufnr

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

local function delete_buffer_prompt(prompt_bufnr)
  local current_picker = actions_state.get_current_picker(prompt_bufnr)
  local current_entry = current_picker:get_selection()

  local bufnr_to_delete = current_entry.bufnr

  local function delete_buffer()
    if (current_bufnr == bufnr_to_delete) then
      vim.defer_fn(function()
        vim.cmd(':echo ""')
        notify("열려있는 버퍼는 삭제할 수 없습니다.", "warn", {
          title = "telescope error",
          timeout = 1000,
        })
      end, 10)
    else
      vim.defer_fn(function()
        vim.cmd(':echo ""')
      end, 0)
      vim.api.nvim_buf_delete(bufnr_to_delete, { force = true })
      current_picker:delete_selection(function()
      end)
    end
  end

  vim.cmd(string.format([[echohl WarningMsg | echo "버퍼를 삭제하시겠습니까? (y or enter/n)"]]))
  local ans = vim.fn.getchar()

  if ans == 121 or ans == 89 or ans == 13 then -- 'y' or 'Y' or <cr>
    delete_buffer()
  end
end

telescope.setup {
  defaults = {
    theme = "ivy",
    file_sorter = sorters.get_fzy_sorter,
    color_devicons = true,
    layout_strategy = "horizontal",
    layout_config = {
      height = 60,
      prompt_position = "top",
      preview_width = 0.6,
    },
    sorting_strategy = "ascending",
    mappings = {
      ["i"] = {
        ["<C-c>"] = function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        end
      },
      ["n"] = {
        ["q"] = function(e)
          actions.close(e)
        end
      },
    },
    initial_mode = "normal",
  },
  extensions = {
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {},
        ["n"] = {
          -- your custom normal mode mappings
          ["N"] = fb_actions.create,
          -- ["h"] = fb_actions.goto_parent_dir,
          ["h"] = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", true)
          end,
          ["c"] = function()
          end,
          ["cc"] = function()
            vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
            vim.cmd('startinsert')
          end,
          -- ["dd"] = function()
          --  vim.api.nvim_buf_set_lines(0, 2, -1, false, {})
          -- end,
          ["dd"] = function()
            local line = vim.api.nvim_get_current_line()
            local new_line = line:match("(>.-)%s.*") or line
            if new_line ~= line then
              new_line = new_line .. " "
            end
            vim.api.nvim_set_current_line(new_line)
          end,
          ["ce"] = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ce", true, false, true), "n", true)
          end,
          ["de"] = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("de", true, false, true), "n", true)
          end,
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
  },
  pickers = {
    buffers = {
      mappings = {
        ["n"] = {
          ["<C-x>"] = delete_buffer_prompt,
          ["<C-r>"] = function(prompt_bufnr)
            actions_state.get_current_picker(prompt_bufnr):refresh()
          end
        }
      }
    }
  }
}

telescope.load_extension("file_browser")

vim.keymap.set('n', ';f',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)
vim.keymap.set('n', ';r', function()
  builtin.live_grep()
end)
vim.keymap.set('n', ';b', function()
  current_bufnr = vim.api.nvim_get_current_buf()
  builtin.buffers()
end)
vim.keymap.set('n', ';t', function()
  builtin.help_tags()
end)
vim.keymap.set('n', ';;', function()
  builtin.resume()
end)
vim.keymap.set('n', ';e', function()
  builtin.diagnostics()
end)
vim.keymap.set("n", "sf", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = true,
    -- layout_config = { height = 40 }
  })
end)
