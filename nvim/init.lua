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
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    config = function()
      require("nvim-tree").setup {
        sort =  {
          sorter = 'case_sensitive',
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      }
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/vim-vsnip',
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ['<C-l>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        }),
        experimental = {
          ghost_text = true,
        },
      })
    end,
  },
  {
    "cappyzawa/trim.nvim",
    opts = {
      trim_on_write = true,
      trim_trailing = true,
    }
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

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fbb', ":Telescope file_browser<CR>", { noremap = true })

-- nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })

-- [[ Plugins ]]
-- Treesitter
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = { 'go', 'lua', 'python', 'tsx', 'javascript', 'typescript', 'ruby', 'bash' },

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)
