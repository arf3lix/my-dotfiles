vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Restore default indentation behavior
vim.keymap.set('n', '>', '>>', { noremap = true, silent = true })
vim.keymap.set('n', '<', '<<', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })

-- toggle line numbers visibility
vim.keymap.set('n', '<leader>n', function()
  if vim.wo.number or vim.wo.relativenumber then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end, { desc = 'Toggle line numbers' })


