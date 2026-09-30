return {
  'mattn/vim-gist',

  dependencies = { 'mattn/webapi-vim' },
  config = function ()
    vim.g.gist_post_private = 1
  end
}

