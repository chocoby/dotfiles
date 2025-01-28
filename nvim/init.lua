-- Base https://github.com/nvim-lua/kickstart.nvim

-- [[ Leader key ]]
vim.g.mapleader = ','

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
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  { "RRethy/nvim-treesitter-endwise" },
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
          dotfiles = false,
          git_ignored = false,
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
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
      end
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        sources = {
          { name = "copilot", group_index = 2 },
          { name = "nvim_lsp", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "buffer" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ['<C-l>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = false },
        }),
        experimental = {
          ghost_text = true,
        },
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
    },
  },
  { "m4xshen/autoclose.nvim" },
  {
    "cappyzawa/trim.nvim",
    opts = {
      trim_on_write = true,
      trim_trailing = true,
    }
  },
  { 'numToStr/Comment.nvim', opts = {} },
  { 'ggandor/leap.nvim' },
  {
    'kylechui/nvim-surround',
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
      })
    end
  },
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
    }
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end
  },
  { "vim-ruby/vim-ruby" },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = function()
      require("ibl").setup({
        indent = {
          char = "|",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = true,
          highlight = "Function"
        }
      })
    end
  }
})

-- [[ Setting options ]]
vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.opt.mouse = 'a'
vim.opt.breakindent = true
vim.opt.cursorline = true
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
vim.keymap.set('n', '<F5>', ':tabprevious<CR>')
vim.keymap.set('n', '<F6>', ':tabnext<CR>')
vim.keymap.set('n', 't', ':tabnew<CR>')
vim.keymap.set('n', 'T', ':tabclose<CR>')

-- Editor
vim.keymap.set('i', ',', ',<Space>')

-- Telescope
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>f/', telescope_live_grep_open_files, { desc = '[F]ind [/] in Open Files' })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').builtin, { desc = '[F]ind [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fG', ':LiveGrepGitRoot<cr>', { desc = '[F]ind by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = '[F]ind [R]esume' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind [B]uffer' })


-- nvim-tree
vim.keymap.set('n', '<F2>', ':NvimTreeToggle<CR>', { silent = true })

-- LSP
vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

-- neotest
vim.keymap.set('n', '<leader>rc', function ()
  require("neotest").run.run()
end, { desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>rr', function ()
  require("neotest").run.run_last()
end, { desc = 'Run last test' })
vim.keymap.set('n', '<leader>rf', function ()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = 'Run current file' })
vim.keymap.set('n', '<leader>rs', function ()
  require('neotest').summary.toggle()
end, { desc = 'Display summary' })
vim.keymap.set('n', '<leader>ro', function ()
  require('neotest').output.open({ enter = true })
end, { desc = 'Display output' })
vim.keymap.set('n', '<leader>rp', function ()
  require('neotest').output_panel.toggle()
end, { desc = 'Display output panel' })


-- [[ Plugins ]]
-- [[ Autoclose ]]
require("autoclose").setup()

-- [[ nvim-treesitter-endwise ]]
require('nvim-treesitter.configs').setup {
  endwise = {
    enable = true,
  },
}

-- [[ Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})


-- Treesitter
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = { 'go', 'lua', 'tsx', 'javascript', 'typescript', 'ruby', 'bash' },

    highlight = { enable = true },
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

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- mason
require('mason').setup()
require('mason-lspconfig').setup()
local servers = {
  solargraph = {
    filetypes = { 'ruby' },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { "vim" } },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- [[ Leap.nvim ]]
require('leap').add_default_mappings()

-- [[ Neotest ]]
require("neotest").setup({
  adapters = {
    require("neotest-rspec")({
      rspec_cmd = function()
        -- FIXME: This is a hack to get the rspec command to work with docker compose
        return vim.tbl_flatten({
          "docker",
          "compose",
          "exec",
          "-i",
          "rails",
          "rspec",
          "-f",
          "json",
          "-o",
          "log/rspec.output",
        })
      end,

      transform_spec_path = function(path)
        local prefix = require('neotest-rspec').root(path)
        return string.sub(path, string.len(prefix) + 2, -1)
      end,

      results_path = "log/rspec.output",
      formatter = "json"
    }),
  },
  output_panel = {
    open = 'botright vsplit | resize 80'
  },
})
