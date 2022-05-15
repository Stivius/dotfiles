local allowed_exts = {'json', 'lua', 'javascript', 'typescript', 'cpp', 'markdown', 'sh'}
vim.api.nvim_create_autocmd({"BufEnter"}, {
	pattern = "*",
	callback = function()
		local ft = vim.api.nvim_buf_get_option(0, 'filetype')
		-- if not table_contains(allowed_exts, ft) then
		-- 	vim.cmd(":CocDisable")
		-- else
		-- 	vim.cmd(":CocEnable")
			-- vim.cmd(":luafile ~/.config/nvim/lua/coc_mappings.lua")
		-- end
	end,
})

vim.cmd("autocmd CursorHold * silent call CocActionAsync('highlight')")

vim.g.coc_snippet_next = '<Tab>';
vim.g.coc_snippet_prev = '<S-Tab>';
