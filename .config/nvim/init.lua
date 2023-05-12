vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- TODO: Consider moving to module config like https://github.com/imbacraft/dusk.nvim/blob/master/nvim/lua/core/pack.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  {'editorconfig/editorconfig-vim'},

  {'TimUntersberger/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = {
      {'<leader>gg', '<cmd>Neogit<cr>', {silent = true, noremap = true}}
    },
    config = true
  },

  { 'lewis6991/gitsigns.nvim', dependencies =  'nvim-lua/plenary.nvim' },

  {'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function () require('todo-comments').setup() end
  },

  {'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  {
    "echasnovski/mini.pairs",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  {'stevearc/overseer.nvim',
    opts = {
      strategy = "toggleterm"
    }
  },

  {'akinsho/toggleterm.nvim',
    opts = {
      open_mapping = [[<c-\>]]
    }
  },

  {'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { "bash", "c", "cpp", "python", "javascript", "json", "markdown", "julia", "go", "typescript", "lua", "rust", "html", "css", "vim", "vimdoc", "yaml"},

      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          -- TODO: I'm not sure for this one.
          scope_incremental = '<c-s>',
          node_decremental = '<c-backspace>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
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
  },

  'nvim-treesitter/nvim-treesitter-textobjects',

  {'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
    },
    config = function () 
      local servers = {
        clangd = {},
        cssls = {},
        pyright = {},
        sqlls = {},
        tsserver = {},
        html = {},
        jsonls = {},
        lua_ls = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = {'vim'} },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false
            },
            telemetry = { enable = false },
          },
        }
      }

      -- LSP settings.
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

        vim.diagnostic.config({
          virtual_text = false,
          signs = true,
          underline = false,
          update_in_insert = false,
          severity_sort = false,
        })

        nmap('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('gr', require('telescope.builtin').lsp_references)
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          if vim.lsp.buf.format then
            vim.lsp.buf.format()
          elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
          end
        end, { desc = 'Format current buffer with LSP' })
      end

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
          }
        end,
      }
    end
  },


  {'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' }
  },

  {'folke/trouble.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = true,
    keys = {
      -- {'<leader>le', '<cmd>TroubleToggle<cr>', {silent = true, noremap = true}}
    }
  },


  {'ishan9299/modus-theme-vim',
    config = function()
      -- vim.cmd [[colorscheme modus-operandi]]
    end
  },

  {'projekt0n/github-nvim-theme',
    config = function()
      require('github-theme').setup{}
      vim.cmd [[colorscheme github_light]]
    end
  },

  {'ggandor/leap.nvim',
    config = function() require('leap').add_default_mappings() end
  },

  {'ggandor/leap-spooky.nvim',
    config = function()
      require('leap-spooky').setup{
        affixes = {
          remote   = { window = 'r', cross_window = 'R' },
          magnetic = { window = 'm', cross_window = 'M' },
        },
        paste_on_remote_yank = false,
      }
    end
  },

  'nvim-lualine/lualine.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'SirVer/ultisnips',
  'lervag/vimtex',
  'L3MON4D3/LuaSnip',
  'ekickx/clipboard-image.nvim',

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- {
  --   "ahmedkhalf/project.nvim",
  --   dependencies = {'nvim-telescope/telescope.nvim'},
  --   keys = {
  --     {'<leader>pp', function() require'telescope'.extensions.projects.projects{} end}
  --   },
  --   -- FIXME: Does not work with config()
  --   init = function()
  --     require("project_nvim").setup()
  --     require('telescope').load_extension('projects')
  --   end
  -- },

  {'gbprod/yanky.nvim',
    lazy = false,
    config = true,
    keys = {
      {'p', '<Plug>(YankyPutAfter)', mode = {"n", "x"}},
      {'P', '<Plug>(YankyPutBefore)', mode = {"n", "x"}},
      {'gp', '<Plug>(YankyGPutAfter)', mode = {"n", "x"}},
      {'gP', '<Plug>(YankyGPutBefore)', mode = {"n", "x"}},
      {'<c-p>', '<Plug>(YankyCycleForward)', mode = {"n", "x"}},
      {'<c-n>', '<Plug>(YankyCycleBackward)', mode = {"n", "x"}}
    },
  },

  {'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = vim.fn.executable "make" == 1
  },

  -- zf proves a better file finding experience
  {'natecraddock/telescope-zf-native.nvim',
    config = function()
      require'telescope'.load_extension("zf-native")
    end
  },

  {'https://github.com/vim-scripts/asm8051.vim',
    ft = 'asm',
    config = function()
      vim.cmd('autocmd BufNewFile,BufRead *.asm set filetype=asm8051')
    end
  },

  {'zbirenbaum/copilot.lua',
    build = ":Copilot auth",
    config = true
  },

})

-- Vim options
vim.o.lazyredraw = true
vim.o.ttyfast = true

vim.o.termguicolors = true

vim.o.hlsearch = false
vim.wo.number = true
vim.wo.relativenumber = true

vim.o.mouse = 'a'

vim.o.breakindent = true

vim.o.clipboard ='unnamedplus'

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.scrolloff=10

vim.o.spell = true
vim.o.spelllang='en_ca'

vim.o.gdefault = true

vim.o.expandtab = true
vim.o.smarttab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.o.swapfile = false

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('n', '<leader>fs', '<Cmd>w<cr>')

-- Use visual line mode unless a prefix number is provided
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<leader>.', ':e ')
vim.keymap.set('n', '<leader>pc', ':e ~/.config/nvim/init.lua<Cr>')

vim.keymap.set('i', '<C-f>', '<right>')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- autosave if file exists on disk
vim.api.nvim_create_autocmd({'InsertLeave', 'CursorHoldI', 'CursorHold'}, {
  pattern = '*',
  callback = function()
    vim.cmd [[if filereadable(expand('%')) | update | endif]]
  end,
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger='<tab>'
vim.g.UltiSnipsJumpBackwardTrigger='<s-tab>'
-- vim.g.UltiSnipsSnippetsDir = '$HOME/.config/nvim/ultisnips'
vim.g.UltiSnipsSnippetDirectories={'ultisnips'}


-- vimtex
vim.g.tex_flavor = 'latex'
vim.o.conceallevel=0
vim.g.tex_conceal=''
vim.g.vimtex_quickfix_mode=0
vim.g.vimtex_view_method = 'zathura'
-- vim.g.vimtex_view_general_viewer = 'zathura'
-- vim.g.vimtex_compiler_progname = 'nvr' -- for synctex

-- Gilles Castel LaTeX setup
vim.cmd([[nnoremap <leader>lc : silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>]])
-- vim.cmd([[nnoremap <leader>le : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>]])

--- clipboard-image
require'clipboard-image'.setup {
  -- Default configuration for all filetype
  default = {
    img_dir = "img",
    img_name = function() return os.date('%Y-%m-%d-%H-%M-%S') end, -- Example result: "2021-04-13-10-04-18"
    affix = "<\n  %s\n>" -- Multi lines affix
  },
  -- You can create configuration for ceartain filetype by creating another field (markdown, in this case)
  -- If you're uncertain what to name your field to, you can run `lua print(vim.bo.filetype)`
  -- Missing options from `markdown` field will be replaced by options from `default` field
  tex = {
    affix = '\\includegraphics[width=\\textwidth]{%s}'
  }
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
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

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>bb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>x', require('telescope.builtin').commands, { desc = '[ ] Command list' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- ripgrep --vimgrep OOM https://github.com/nvim-telescope/telescope.nvim/issues/647
vim.keymap.set('n', '<leader>sp', function() require('telescope.builtin').live_grep{additional_args = {"-j1" }} end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)


-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())


-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')


-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'


cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}



-- Task runner
local tasks = {}

function load_tasks()

  local task_file = io.open("./tasks", "r")
  if task_file == nil then
    return tasks
  end

  for line in task_file:lines() do
    local name, command = string.match(line, "^(.+):%s*(.+)$")
    if name ~= nil and command ~= nil then
      tasks[name] = command
    end
  end

  task_file:close()
  return tasks
end

function run_task()

  load_tasks()
  local task_names = {}
  for name, _ in pairs(tasks) do
    table.insert(task_names, name)
  end

  if #task_names == 0 then
    print("No tasks found")
    return
  end

  local on_choice = function(selected_index)
    if selected_index == nil then
      return
    end
    local selected_task = tasks[selected_index]
    local toggleterm = require("toggleterm")
    toggleterm.exec(selected_task)
  end

  vim.ui.select(task_names, {
    title = "Select a task",
    prompt = "Task: ",
  },
    on_choice)
end

function load_task(task_name)
  local task_func = tasks[task_name]
  if not task_func then
    print("Task not found:", task_name)
    return
  end

  _G[task_name] = task_func
  print("Loaded task:", task_name)
end

vim.api.nvim_set_keymap("n", "<leader>r", ":lua run_task()<CR>", { noremap = true })

-- vim: ts=2 sts=2 sw=2 et
