vim.o.expandtab = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.clipboard = 'unnamedplus'
vim.o.laststatus = 3
vim.o.updatetime = 100
vim.o.scrolloff = 12
vim.o.winborder = 'rounded'

vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')
