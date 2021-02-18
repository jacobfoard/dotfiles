local M = {}

function M.is_buffer_empty()
  -- Check whether the current buffer is empty
  return vim.fn.empty(vim.fn.expand("%:t")) == 1
end

function M.has_width_gt(cols)
  -- Check if the windows width is greater than a given number of columns
  return vim.fn.winwidth(0) / 2 > cols
end

-- https://github.com/norcalli/nvim_utils
-- local autocmds = {
-- 	todo = {
-- 		{"BufEnter",     "*.todo",              "setl ft=todo"};
-- 		{"BufEnter",     "*meus/todo/todo.txt", "setl ft=todo"};
-- 		{"BufReadCmd",   "*meus/todo/todo.txt", [[silent call rclone#load("db:todo/todo.txt")]]};
-- 		{"BufWriteCmd",  "*meus/todo/todo.txt", [[silent call rclone#save("db:todo/todo.txt")]]};
-- 		{"FileReadCmd",  "*meus/todo/todo.txt", [[silent call rclone#load("db:todo/todo.txt")]]};
-- 		{"FileWriteCmd", "*meus/todo/todo.txt", [[silent call rclone#save("db:todo/todo.txt")]]};
-- 	};
-- 	vimrc = {
-- 		{"BufWritePost init.vim nested source $MYVIMRC"};
-- 		{"FileType man setlocal nonumber norelativenumber"};
-- 		{"BufEnter term://* setlocal nonumber norelativenumber"};
-- 	};
-- }
-- nvim_create_augroups(autocmds)
local api = vim.api
function M.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command("augroup " .. group_name)
    api.nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      -- if type(def) == 'table' and type(def[#def]) == 'function' then
      -- 	def[#def] = lua_callback(def[#def])
      -- end
      local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
      api.nvim_command(command)
    end
    api.nvim_command("augroup END")
  end
end

return M
