-- Base https://github.com/nvim-lua/kickstart.nvim

-- [[ Leader key ]]
vim.g.mapleader = '\\'

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
require('lazy').setup({
  {
    'rktjmp/lush.nvim',
    priority = 1000,
  },
  {
    'metalelf0/jellybeans-nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'jellybeans-nvim'
    end,
  },
})

-- [[ Setting options ]]
vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.opt.mouse = 'a'
vim.opt.breakindent = true
vim.opt.cursorline = false
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = 'menuone,noselect'
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.whichwrap = "b,s,h,l,[,],<,>"
vim.opt.backspace = "indent,eol,start"
vim.opt.wildignore = { '*/.git/*', '*/.bundle/*', '*/node_modules/*', '*/tmp/*' }

-- Tab
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf"
    },
    paste = {
      ["+"] = "win32yank.exe -o --crlf",
      ["*"] = "win32yank.exe -o --crlf"
    },
    cache_enable = 0,
  }
end

-- [[ Keymap ]]
vim.keymap.set('n', '<Space>', 'jzz', { noremap = true, silent = true })
vim.keymap.set('i', 'jj', '<ESC>', { silent=true })
vim.keymap.set('n', ';', ':', { silent=true })
vim.keymap.set('n', '<Esc><Esc>', ':<C-u>set nohlsearch<Return>')

-- Window
vim.keymap.set('n', '<leader>se', '<C-w>=')
vim.keymap.set('n', '<leader>sx', ':close<CR>')
vim.keymap.set('n', '<leader>sw', '<C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>><C-w>>')
vim.keymap.set('n', '<leader>st', '<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><<C-w><')

-- Tab
vim.keymap.set('n', 't', ':tabnew<CR>')
vim.keymap.set('n', 'T', ':tabclose<CR>')

-- Editor
vim.keymap.set('i', ',', ',<Space>', opts)
