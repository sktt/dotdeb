return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local signs = { Error = "󰅚", Warn = "󰀪", Info = "󰋽", Hint = "󰌶" }

      local diagnostic_signs = {}
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        -- vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        diagnostic_signs[hl] = { text = icon }
      end

      vim.diagnostic.config({
        signs = diagnostic_signs,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- LSP keymaps
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
      vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition)
      vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition)
      vim.keymap.set("n", "<leader>ji", vim.lsp.buf.implementation)
      vim.keymap.set("n", "<leader>jr", vim.lsp.buf.references)
      vim.keymap.set("n", "?", vim.lsp.buf.hover)
      vim.keymap.set("n", "<leader>?", vim.diagnostic.open_float)
      vim.keymap.set("n", "<leader>F", vim.lsp.buf.format)

      local function quickfix()
          vim.lsp.buf.code_action({
              filter = function(a) return a.isPreferred end,
              apply = true
          })
      end
      vim.keymap.set("n", "<leader>qf", quickfix)

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local _clangd_on_attach = vim.lsp.config.clangd.on_attach
      vim.lsp.config.clangd = {
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
        on_attach = function(_client, bufnr)
          -- `?` is hover here; K is only buffer-mapped on some nvim versions
          pcall(vim.keymap.del, "n", "K", { buffer = bufnr })
          if _clangd_on_attach then         -- <- CHECK NIL
            _clangd_on_attach(_client, bufnr)
          end

          vim.keymap.set('n', '<Leader>e', ':LspClangdSwitchSourceHeader<cr>', { buffer = true, silent = true })
        end,
      }

      vim.lsp.enable('clangd')

      vim.lsp.config('*', {
        root_markers = { '.git' },
      })

      -- Local checkout, not on every machine
      local tidal_lsp = vim.fn.expand('~/_code/tidal-lsp/run')
      vim.lsp.config.tidal = {
        cmd = { tidal_lsp },
        capabilities = capabilities,
        filetypes = { 'tidal' },
      }

      vim.lsp.config.lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT', },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        }
      }

      -- vim.lsp.log.set_level 'trace'
      -- clangd is enabled above; mason installs these two (see mason.lua)
      vim.lsp.enable({ 'lua_ls', 'rust_analyzer' })
      if vim.fn.executable(tidal_lsp) == 1 then
        vim.lsp.enable('tidal')
      end
    end
  },
}
