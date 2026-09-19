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
  -- "folke/which-key.nvim",
  -- "RRethy/base16-nvim",
  -- 'tpope/vim-surround',
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = true,
        terminal_colors = true,
        on_colors = function(c)
          c.comment = c.dark5
        end,
        on_highlights = function(highlights, c)
          highlights.ColorColumn = { bg = c.blue7 }
        end
      })
      vim.cmd.colorscheme("tokyonight")
    end
  },
  {
    'mattn/vim-gist',
    dependencies = { 'mattn/webapi-vim' },
    config = function()
      vim.g.gist_detect_filetype = 1
      vim.g.gist_open_browser_after_post = 1
      vim.g.gist_post_private = 1
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>t', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
      vim.keymap.set("n", "<leader>g", live_grep_args_shortcuts.grep_word_under_cursor)



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
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
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
      { 'hrsh7th/cmp-nvim-lsp' },
    }
  },
  -- Autocompletion
  'honza/vim-snippets',
  {
    'SirVer/ultisnips',
    config = function ()
      vim.g.UltiSnipsSnippetsDir = "~/.vim/UltiSnips"
      vim.g.UltiSnipsExpandTrigger = "<c-x>"
      vim.g.UltiSnipsJumpForwardTrigger="<c-j>"
      vim.g.UltiSnipsJumpBackwardTrigger="<c-k>"
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'SirVer/ultisnips',
      'quangnguyen30192/cmp-nvim-ultisnips',
    },
    event = "InsertEnter",
    config = function()
      local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
      local cmp = require 'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'ultisnips' }
        }),
        mapping = {
          ["<Tab>"] = cmp.mapping(
            function()
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n")
              -- fallback()
              --cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
            end, { "i", "s"}),
          ["<S-Tab>"] = cmp.mapping(
            function(fallback)
              cmp_ultisnips_mappings.jump_backwards(fallback)
            end, { "i", "s" }),
        },
      })
    end

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
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
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
    config = function()
      vim.cmd([[nnoremap <Leader>n :Neotree toggle<cr>]])
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
              hide_dotfiles = false,
              hide_gitignored = false,
          },
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
    enabled = false,
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
        auto_install = false,
        sync_install = false,
        ensure_installed = {
          "c",
          "bash",
          'javascript',
          'typescript',
          'html',
          'json',
          'css',
          'rust',
          'lua',
          'go',
          'markdown',
          'latex',
        },

        highlight = {
          enable = true,
        },
        indent = { enable = true, }
      }
    end
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        tex = { "vale", },
        context = { "vale", },
        plaintex = { "vale", }
      }

      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          require("lint").try_lint();
        end
      })
    end
  }
})

vim.keymap.set({"n","v"}, "<leader>1", function()
  vim.cmd("let @+ = @")
end, {desc = "copy clipboard into system clipboard"})

vim.keymap.set({"n","v"}, "<leader>`", function()
  if vim.o.clipboard == "" then
    vim.o.clipboard = "unnamedplus"
  else
    vim.o.clipboard = ""
  end
  vim.cmd("redrawstatus");
end, { desc = "Toggle clipboard usage" })

function _G.clipboard_status()
  if vim.o.clipboard == "" then
    return "clip: VIM"
  elseif vim.o.clipboard == "unnamedplus" then
    return "clip: SYS"
  else
    return vim.o.clipboard
  end
end
vim.o.statusline = "%f %h%m%r %=%y | %l:%c | %p%% | %{v:lua.clipboard_status()}"



-- vim.o.clipboard = 'unnamedplus'
-- vim.cmd.colorscheme("base16-atelier-dune")
vim.g.netrw_banner = 0 -- remove netrw banner
vim.opt.tabstop = 8
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.termguicolors = true
vim.opt.lbr = true
vim.opt.textwidth = 80
vim.opt.so = 7
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess:append("I")

vim.cmd([[nnoremap j gj]])
vim.cmd([[nnoremap k gk]])

vim.api.nvim_create_autocmd("FileType", {
  pattern = { 'tex', 'plaintex' },
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = "en_us"
    vim.opt.textwidth = 0
    vim.opt.wrap = true
  end,
})

vim.cmd("set colorcolumn=+1")
-- vim.cmd("hi Normal guibg=NONE")
--highlight ColorColumn guibg=#303030
vim.keymap.set('n', '<Leader>h', ":set hlsearch!<cr>")
vim.keymap.set('n', '<Leader>x', ":bp|bd #<cr>")
vim.keymap.set('n', 'L', ":bnext<cr>")
vim.keymap.set('n', 'H', ":bprevious<cr>")
vim.keymap.set('n', '<Leader>v', ":tabedit $MYVIMRC<cr>")
vim.keymap.set('n', '<Leader>q', "gqap")
vim.keymap.set('n', '<Leader>l', ':set list!<CR> " Toggle invisible chars$"')
vim.keymap.set('n', '<Leader>e', ':ClangdSwitchSourceHeader<cr>')
-- vim.keymap.set("x", "Y", '"+y', { noremap = true })
-- vim.keymap.set("n", "Y", '"+y', { noremap = true })
-- vim.keymap.set("x", "P", '"+p', { noremap = true })
-- vim.keymap.set("n", "P", '"+p', { noremap = true })
-- vim.g.base16colorspace = 256

-- let @+ = @"

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(_, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  local opts = { buffer = bufnr }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<leader>ji", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<leader>jr", vim.lsp.buf.references, opts)
  -- vim.keymap.set("n", "?", function() vim.lsp.buf.hover() end, opts)
  -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  -- vim.keymap.set("n", "?", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  -- vim.keymap.set("n", "?", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "?", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<F4>", vim.lsp.buf.format, opts)
end)
lsp_zero.setup_servers({ 'tsserver', 'eslint', 'rust_analyzer', 'clangd' })

--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { 'tsserver', 'rust_analyzer' },
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
-- Highlight entire line for errors
-- Highlight the line number for warnings
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
});
