return {
  'davidgranstrom/scnvim',
  ft = { 'supercollider', 'tidal' },
  config = function()
    local scnvim = require('scnvim')
    local map = scnvim.map
    local map_expr = scnvim.map_expr
    scnvim.setup {
      sc_port = 57120,

      keymaps = {
        ['<M-e>'] = map('editor.send_line', { 'i', 'n' }),
        ['<C-e>'] = {
          map('editor.send_block', { 'i', 'n' }),
          map('editor.send_selection', 'x'),
        },
        ['<CR>'] = map('postwin.toggle'),
        ['<M-CR>'] = map('postwin.toggle', 'i'),
        ['<M-L>'] = map('postwin.clear', { 'n', 'i' }),
        ['<F12>'] = map('sclang.hard_stop', { 'n', 'x', 'i' }),
        ['<leader>st'] = map(scnvim.start),
        ['<leader>sk'] = map(scnvim.recompile),
        ['<F1>'] = map_expr('s.boot'),
        ['<F2>'] = map_expr('s.meter'),

        ['<F5>'] = map('editor.send_block', { 'i', 'n' }),
        ['<C-CR>'] = map('postwin.toggle', 'i'),
        ['<leader>l'] = map('postwin.clear', 'n'),
        ['<F3>'] = map(function()
          require 'telescope'.extensions.scdoc.sc_definitions()
        end, { 'n', 'x', 'i' }),
      },
      editor = {
        highlight = {
          color = 'IncSearch',
          type = 'flash',
          flash = {
            repeats = 3,
          }
        },
      },
    }
  end
}