local map = vim.api.nvim_set_keymap

local mapper = function(mode, key, result, isLua)
  if isLua then result = "<cmd>lua " .. result .. "<CR>" end
  map(mode, key, result, {noremap = true, silent = true})
end

mapper("n", "<C-p>", "require'telescope'.extensions.project.project{}", true)

-- Highlights code for multiple indents without reselecting
mapper("v", "<", "<gv")
mapper("v", ">", ">gv")
mapper("n", "<", "<<")
mapper("n", ">", ">>")

mapper("", "<C-g>", "require('telescope.builtin').live_grep()", true)
-- <Ctrl-l> redraws the screen and removes any search highlighting.
mapper("n", "<C-l>", "<cmd> noh<CR><C-l>")

mapper("n", "-", "<cmd> ChooseWinSwap<cr>")

-- Shift move lines
mapper("n", "<S-Up>", "<cmd> m .-2<CR>==")
mapper("n", "<S-Down>", "<cmd> m .+1<CR>==")
mapper("i", "<S-Up>", "<Esc>:m .-2<CR>==gi")
mapper("i", "<S-Down>", "<Esc>:m .+1<CR>==gi")
mapper("v", "<S-Down>", ":m '>+1<CR>gv=gv")
mapper("v", "<S-Up>", ":m '<-2<CR>gv=gv")

-- Resize buffers
mapper("n", "<M-up>", "<cmd>resize -5<cr>")
mapper("n", "<M-down>", "<cmd>resize +5<cr>")
mapper("n", "<M-left>", "<cmd>vertical resize -5<cr>")
mapper("n", "<M-right>", "<cmd>vertical resize +5<cr>")
-- esc works like normal in a term
mapper("t", "<ESC>", "<C-\\><C-N>")
-- autocmd TermOpen * setlocal nonu

-- center on page down
mapper("n", "<PageDown>", "<PageDown>zz")
mapper("i", "<PageDown>", "<ESC><PageDown>zzi")

mapper("", "<C-f>", "require('telescope.builtin').find_files()", true)
mapper("n", "nt", "<cmd>NvimTreeToggle<cr>")

local remap = vim.api.nvim_set_keymap
local npairs = require("nvim-autopairs")

local t = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

_G.Utils = {}

Utils.check_backspace = function()
  local curr_col = vim.fn.col(".")
  local is_first_col = vim.fn.col(".") - 1 == 0
  local prev_char = vim.fn.getline("."):sub(curr_col - 1, curr_col - 1)

  if is_first_col or prev_char:match("%s") then
    return true
  else
    return false
  end
end

Utils.completion_confirm = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      vim.fn["compe#confirm"]()
      return npairs.esc("")
    else
      vim.fn.nvim_select_popupmenu_item(0, false, false, {})
      vim.fn["compe#confirm"]()
      return npairs.esc("<c-n>")
    end
  else
    return npairs.check_break_line_char()
  end
end

remap("i", "<CR>", "v:lua.Utils.completion_confirm()", {expr = true, noremap = true})

Utils.tab = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      vim.fn["compe#confirm"]()
      return npairs.esc("")
    else
      vim.fn.nvim_select_popupmenu_item(0, false, false, {})
      vim.fn["compe#confirm"]()
      return npairs.esc("<c-n>")
    end
  else
    if vim.fn["vsnip#available"](1) == 1 then
      if vim.fn["vsnip#expandable"]() == 1 then
        vim.fn["vsnip#expand"]()
      else
        vim.api.nvim_feedkeys(t("<Plug>(vsnip-jump-next)"), "i", true)
      end
      return ""
    elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
      return t("<C-R>=UltiSnips#ExpandSnippet()<CR>")
    elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
      return t("<C-R>=UltiSnips#JumpForwards()<CR>")
    end
    return t "<Tab>"
  end
end

remap("i", "<Tab>", "v:lua.Utils.tab()", {expr = true, noremap = true})
remap("i", "<S-Tab>", "pumvisible() ? \"<C-p>\" : \"<S-Tab>\"", {noremap = true, expr = true})
remap("i", "<C-Space>", "compe#confirm()", {noremap = true, expr = true, silent = true})
remap("i", "<C-p>", "compe#complete()", {noremap = true, expr = true, silent = true})
