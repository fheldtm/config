local status, hop = pcall(require, "hop")
if (not status) then return end

hop.setup {
  keys = 'etovxqpdygfblzhckisuran',
  term_seq_bias = 0.5
}

local directions = require('hop.hint').HintDirection
vim.keymap.set('n', 'f', function() hop.hint_char1() end, { remap = true })
vim.keymap.set('n', '2f', function() hop.hint_char2() end, { remap = true })
vim.keymap.set('n', 'F', function() hop.hint_words() end, { remap = true })
