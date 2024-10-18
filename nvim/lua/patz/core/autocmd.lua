-- Autocommands

-- Set the cursor line to have a line at the bottom
vim.cmd [[
	autocmd BufEnter * highlight CursorLine gui=underline
]]

-- Highlight on yank
vim.cmd [[
	augroup YankHighlight
		autocmd!
		autocmd TextYankPost * silent! lua vim.highlight.on_yank()
	augroup end
]]

-- Turn off cursor when changing buffer
vim.cmd [[
	augroup cursor_off
		autocmd!
		autocmd WinLeave * set nocursorline nocursorcolumn
		autocmd WinEnter * set cursorline cursorcolumn
	augroup END
]]

-- DAP
-- Autocompletion
vim.cmd [[
  au FileType dap-repl lua require('dap.ext.autocompl').attach()
]]

-- disable IBL plugin on Markdown files
vim.api.nvim_create_autocmd({"FileType"}, {
	pattern = {"markdown"},
	command = "IBLDisable"
})
--
-- Conceal in Neorg
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
	pattern = {"*.norg"},
	command = "set conceallevel=3"
})

-- C files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
  end,
})
