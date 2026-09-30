return {
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'SirVer/ultisnips' },
  { 'honza/vim-snippets' },
  { 'quangnguyen30192/cmp-nvim-ultisnips' },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require 'cmp'

      cmp.setup({
        snippet = {
          expand = function(args)
            -- no snippet engine, just buffer completion
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'ultisnips' }, -- For ultisnips users.
        }, {
          { name = 'buffer' },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'cmp_docs',
        callback = function()
          if vim.bo.filetype == 'tidal' then
            vim.bo.filetype = 'haskell'  -- or whichever syntax you want for Tidal
          end
        end,
      })

      -- SuperCollider specific
      cmp.setup.filetype('supercollider', {
        sources = cmp.config.sources({
          { name = 'buffer' },
          { name = 'scnvim', keyword_length = 2 }, -- SC autocompletion
        })
      })
    end
  },
}
