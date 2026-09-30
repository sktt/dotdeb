return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      tex = { "vale" },
      context = { "vale" },
      plaintex = { "vale" },
    }

    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        -- vale isn't installed everywhere; skip rather than error on save
        if vim.fn.executable("vale") == 1 then
          require("lint").try_lint()
        end
      end,
    })
  end,
}
