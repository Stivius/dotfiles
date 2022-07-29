function merge(first_table, second_table)
	for k,v in pairs(second_table) do first_table[k] = v end
	return first_table
end

function set_option(option, value)
	vim.api.nvim_set_option(option, value)
end

function set_win_option(option, value)
	vim.api.nvim_win_set_option(0, option, value)
end

function table_contains(table, val)
   for i=1,#table do
      if table[i] == val then
         return true
      end
   end
   return false
end

function print_table(tbl)
	print('Printing table...')
	for k,v in pairs(tbl) do print(k, v) end
end

function set_keymap(mode, lhs, rhs, opts, additional_opts)
	opts = opts or {}
	additional_opts = additional_opts or {}
	local all_opts = merge(opts, additional_opts)
	if all_opts['buffer'] then
		all_opts['buffer'] = nil
		vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, all_opts)
	else
		vim.api.nvim_set_keymap(mode, lhs, rhs, all_opts)
	end
end

function create_user_command(command_name, callback, opts)
	if opts['buffer'] then
		opts['buffer'] = nil
		vim.api.nvim_buf_create_user_command(0, command_name, callback, opts)
	else
		vim.api.nvim_create_user_command(command_name, callback, opts)
	end
end

function map(lhs, rhs, opts) set_keymap('', lhs, rhs, opts) end
function map_local(lhs, rhs, opts) set_keymap('', lhs, rhs, { buffer = true }, opts) end
function noremap(lhs, rhs, opts) set_keymap('', lhs, rhs, { noremap = true }, opts) end
function noremap_local(lhs, rhs, opts) set_keymap('', lhs, rhs, { noremap = true, buffer = true }, opts) end
function nmap(lhs, rhs, opts) set_keymap('n', lhs, rhs, opts) end
function nmap_local(lhs, rhs, opts) set_keymap('n', lhs, rhs, { buffer = true }, opts) end
function nnoremap(lhs, rhs, opts) set_keymap('n', lhs, rhs, { noremap = true }, opts) end
function nnoremap_local(lhs, rhs, opts) set_keymap('n', lhs, rhs, { noremap = true, buffer = true }, opts) end
function vmap(lhs, rhs, opts) set_keymap('v', lhs, rhs, opts) end
function vmap_local(lhs, rhs, opts) set_keymap('v', lhs, rhs, { buffer = true }, opts) end
function vnoremap(lhs, rhs, opts) set_keymap('v', lhs, rhs, { noremap = true }, opts) end
function vnoremap_local(lhs, rhs, opts) set_keymap('v', lhs, rhs, { noremap = true, buffer = true }, opts) end
function imap(lhs, rhs, opts) set_keymap('i', lhs, rhs, opts) end
function imap_local(lhs, rhs, opts) set_keymap('i', lhs, rhs, { buffer = true}, opts) end
function inoremap(lhs, rhs, opts) set_keymap('i', lhs, rhs, { noremap = true }, opts) end
function inoremap_local(lhs, rhs, opts) set_keymap('i', lhs, rhs, { noremap = true, buffer = true }, opts) end
function xmap(lhs, rhs, opts) set_keymap('x', lhs, rhs, opts) end
function xmap_local(lhs, rhs, opts) set_keymap('x', lhs, rhs, { buffer = true }, opts) end
function omap(lhs, rhs, opts) set_keymap('o', lhs, rhs, opts) end
function omap_local(lhs, rhs, opts) set_keymap('o', lhs, rhs, { buffer = true }, opts) end
function tmap(lhs, rhs, opts) set_keymap('t', lhs, rhs, opts) end


