return {
 "thgrund/tidal.nvim",
 opts = {
  --- Set to false to disable all default mappings
  --- @type table | nil
  mappings = {
    -- send_line = { mode = { "i", "n" }, key = "<S-CR>" },
    send_line = { mode = { "i", "n" }, key = "<C-e>" },
    send_visual = { mode = { "x" }, key = "<S-CR>" },
    send_block = { mode = { "i", "n", "x" }, key = "<M-CR>" },
    send_node = { mode = "n", key = "<leader><CR>" },
    send_silence = { mode = "n", key = "<leader>d" },
    send_hush = { mode = "n", key = "<leader><Esc>" },
  },
  ---- Configure highlight applied to selections sent to tidal interpreter
  selection_highlight = {
    --- Highlight definition table
    --- see ':h nvim_set_hl' for details
    --- @type vim.api.keyset.highlight
    highlight = { link = "IncSearch" },
    --- Duration to apply the highlight for
    timeout = 150,
  },
 },
 -- Recommended: Install TreeSitter parsers for Haskell and SuperCollider
 dependencies = {
  "nvim-treesitter/nvim-treesitter",
  opts = { ensure_installed = { "haskell", "supercollider" } },
 },
}
