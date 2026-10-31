vim.api.nvim_create_autocmd("FileType", {
  pattern = "mail",
  callback = function()
    vim.opt_local.textwidth = 72
  end
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.sc",
  command = "set filetype=supercollider"
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.tidal",
  command = "set filetype=tidal"
})
