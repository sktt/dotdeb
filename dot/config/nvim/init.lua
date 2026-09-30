vim.opt.signcolumn = 'yes'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
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

require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

require("config.filetypes")

vim.opt.shortmess:append('I')
vim.o.clipboard = 'unnamedplus'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.termguicolors = true
vim.opt.linebreak= true
vim.opt.textwidth = 80
vim.opt.scrolloff = 7
vim.opt.laststatus = 3
vim.opt.colorcolumn = "+1"
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.cmd("set switchbuf=usetab,newtab,split")
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    local opts = { buffer = true }
    vim.keymap.set("n", "q", "<cmd>cclose<cr>", { buffer = true })
    -- open in horizontal split
    -- vim.keymap.set("n", "<CR>", "<C-w><CR><C-w>K", opts)
    -- or vertical split (pick one)
    vim.keymap.set("n", "<S-CR>", "<C-w><CR><C-w>H", opts)
    -- vim.keymap.set("n", "<CR>", "<C-w><CR><C-w>H", opts)
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*",
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "quickfix" then
        vim.cmd("cclose")
        break
      end
    end
  end,
})

--highlight ColorColumn guibg=#303030
--
vim.keymap.set('n', '<Leader>h', ":set hlsearch!<cr>")
vim.keymap.set('n', '<Leader>x', ":bp|bd #<cr>")
vim.keymap.set('n', 'L', ":bnext<cr>")
vim.keymap.set('n', 'H', ":bprevious<cr>")
vim.keymap.set('n', '<Leader>v', ":tabedit " .. vim.fn.stdpath("config") .. "<cr>")

--if get(g:, "tmux_syntax_colors", 1)
--  augroup tmux_colors
--    autocmd!
--    autocmd FileType tmux call s:TmuxColors()
--  augroup END
--
--  function! s:TmuxColors() abort
--    for i in range(0, 255)
--      let bg = (!i || i == 16 || (i > 231 && i < 235)) ? 15 : "NONE"
--
--      execute 'syntax match tmuxColour' . i . ' /\<colou\?r' . i . '\>/ containedin=ALL'
--
--      execute 'highlight tmuxColour' . i .
--            \ ' ctermfg=' . i .
--            \ ' ctermbg=' . bg .
--            \ ' guifg=NONE guibg=NONE'
--    endfor
--  endfunction
--endif
-- if vim.g.tmux_syntax_colors ~= 0 then
--   vim.api.nvim_create_augroup("tmux_colors", { clear = true })
--
--   vim.api.nvim_create_autocmd("FileType", {
--     group = "tmux_colors",
--     pattern = "tmux",
--     callback = function()
--       for i = 0, 255 do
--         local bg = (i == 0 or i == 16 or (i > 231 and i < 235)) and 15 or "NONE"
--
--         vim.cmd(string.format(
--           "syntax match tmuxColour%d /\\<colou\\?r%d\\>/ containedin=ALL",
--           i, i
--         ))
--
--         vim.cmd(string.format(
--           "highlight tmuxColour%d ctermfg=%d ctermbg=%s guifg=NONE guibg=NONE",
--           i, i, bg
--         ))
--       end
--     end,
--   })
-- end
local function xterm_to_hex(i)
  if i < 16 then
    local ansi = {
      "#000000","#800000","#008000","#808000",
      "#000080","#800080","#008080","#c0c0c0",
      "#808080","#ff0000","#00ff00","#ffff00",
      "#0000ff","#ff00ff","#00ffff","#ffffff"
    }
    return ansi[i+1]
  elseif i < 232 then
    i = i - 16
    local r = math.floor(i / 36)
    local g = math.floor((i % 36) / 6)
    local b = i % 6
    local function v(n) return n == 0 and 0 or 55 + n * 40 end
    return string.format("#%02x%02x%02x", v(r), v(g), v(b))
  else
    local c = 8 + (i - 232) * 10
    return string.format("#%02x%02x%02x", c, c, c)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tmux",
  callback = function()
    for i = 0, 255 do
      local hex = xterm_to_hex(i)
      vim.api.nvim_set_hl(0, "tmuxColour"..i, {
        fg = hex
      })
    end
  end
})
