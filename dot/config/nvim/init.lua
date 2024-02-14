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

vim.g.mapleader = " "

require("lazy").setup({
  "folke/which-key.nvim",
  "RRethy/base16-nvim",
  'tpope/vim-surround',
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>t', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
              ["<C-u>"] = false
            }
          }
        }
      })
    end
  },
  {
    'numToStr/Comment.nvim',
    opts = {
	    toggler = {
		    ---Line-comment toggle keymap
		    line = '<Leader>c<Leader>',
		    ---Block-comment toggle keymap
		    block = 'gbc',
	    },
	    opleader = {
		    ---Line-comment keymap
		    line = '<Leader>c<Leader>',
		    ---Block-comment keymap
		    block = '<Leader>cs',
	    },
    },
    lazy = false,
  },
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  -- LSP Support
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    -- config = false,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
    }
  },
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {'L3MON4D3/LuaSnip'}
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function ()
      vim.cmd([[nnoremap <Leader>n :Neotree toggle<cr>]])
      require("neo-tree").setup({
        filesystem = {
          window = {
            mappings = {
              ["o"] = {
                "open",
                nowait = true
              }
            }
          }
        }
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "windwp/nvim-ts-autotag" },
    build = ':TSUpdate',
    event = 'BufReadPost',
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        auto_install = true,
        sync_install = false,
        ensure_installed = {
          "c",
          'javascript',
          'typescript',
          'html',
          'json',
          'css',
          'rust',
          'lua',
          'go',
          'markdown',
        },
        highlight = {
          enable = true,
        }
      }
    end
  }
  -- "github/copilot.vim",
})

vim.o.clipboard = 'unnamedplus'
vim.cmd.colorscheme("base16-atelier-dune")
vim.opt.tabstop = 8
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.termguicolors = true
vim.opt.lbr = true
vim.opt.textwidth = 80
vim.opt.so = 7
vim.cmd("set colorcolumn=+1")
vim.cmd("hi Normal guibg=NONE")
--highlight ColorColumn guibg=#303030
vim.keymap.set('n', '<Leader>h', ":set hlsearch!<cr>")
vim.keymap.set('n', '<Leader>x', ":bp|bd #<cr>")
vim.keymap.set('n', 'L', ":bnext<cr>")
vim.keymap.set('n', 'H', ":bprevious<cr>")
vim.keymap.set('n', '<Leader>v', ":tabedit $MYVIMRC<cr>")
vim.g.base16colorspace = 256

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(_, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  local opts = {buffer = bufnr}
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "<leader>jd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

end)
lsp_zero.setup_servers({'tsserver', 'eslint', 'rust_analyzer', 'clangd'})

--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'rust_analyzer'},
  handlers = {
    lsp_zero.default_setup,
  },
})

local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
  on_init = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end
}
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
          'require'
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_init = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end
}
