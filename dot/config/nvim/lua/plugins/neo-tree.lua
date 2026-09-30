return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  config = function()
    vim.keymap.set('n', '<Leader>n', ':Neotree toggle<CR>', { silent = true })
    require('neo-tree').setup({
      window = {
        mappings = {
          ["o"] = "open",                 -- like NERDTree: open file or expand dir
          ["<CR>"] = "open",              -- also open on Enter
          ["<2-LeftMouse>"] = "open",     -- double-click
          ["t"] = "open_tabnew",          -- open in new tab
          ["T"] = "open_tab_drop",        -- like NERDTree's “t” (optional)
          ["s"] = "open_split",           -- open in horizontal split
          ["i"] = "open_vsplit",          -- open in vertical split
          ["C"] = "close_node",           -- collapse dir
          ["u"] = "navigate_up",          -- go up a directory
          ["U"] = "navigate_up",          -- optional duplicate
          ["r"] = "refresh",              -- refresh tree

          ["od"] = "noop",
          ["ot"] = "noop",
          ["og"] = "noop",
          ["os"] = "noop",
          ["on"] = "noop",
          ["om"] = "noop",
          ["oc"] = "noop",
          ["Od"] = "order_by_diagnostics",
          ["Ot"] = "order_by_type",
          ["Og"] = "order_by_git_status",
          ["Os"] = "order_by_size",
          ["On"] = "order_by_name",
          ["Om"] = "order_by_modified",
          ["Oc"] = "order_by_created",

          ["/"] = 'noop',

          ["m"] = "noop",
          ["a"] = "noop",
          ["d"] = "noop",
          ["c"] = "noop",
          ["p"] = "noop",
          -- ["r"] = "noop",
          ["mm"] = "move",
          ["mr"] = "rename",
          ["ma"] = "add",
          ["md"] = "delete",
          ["mc"] = "copy",
          ["mp"] = "paste",
          -- ["mr"] = "refresh",
        },
      },
    })
    end,
}
