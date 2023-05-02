local keymap = vim.keymap

-- Ctrl C to ESC
keymap.set('n', '<C-c>', '<Escape>')
keymap.set('i', '<C-c>', '<Escape>')

-- Do not yank with x
keymap.set('n', 'x', '"_x')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Select all
-- keymap.set('n', '<C-a>', 'gg<S-v>G')

-- New tab
keymap.set('n', 'te', ':tabedit<Return>', { silent = true })
-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w', { silent = true })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { silent = true })
-- Move window
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('n', 's<left>', '<C-w>h')
keymap.set('n', 's<up>', '<C-w>k')
keymap.set('n', 's<down>', '<C-w>j')
keymap.set('n', 's<right>', '<C-w>l')
keymap.set('n', 'sh', '<C-w>h')
keymap.set('n', 'sk', '<C-w>k')
keymap.set('n', 'sj', '<C-w>j')
keymap.set('n', 'sl', '<C-w>l')

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')

-- default key unbind
keymap.set('n', 's', '<Nop>', { silent = true })
keymap.set('n', 'S', '<Nop>', { silent = true })
