function merge(first_table, second_table)
	for k,v in pairs(second_table) do first_table[k] = v end
	return first_table
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
function noremap(lhs, rhs, opts) set_keymap('', lhs, rhs, { noremap = true }, opts) end
function nmap(lhs, rhs, opts) set_keymap('n', lhs, rhs, opts) end
function nnoremap(lhs, rhs, opts) set_keymap('n', lhs, rhs, { noremap = true }, opts) end
function test_map(rhs, lhs)
	nnoremap(lhs, rhs, { buffer = true })
end
function vmap(lhs, rhs, opts) set_keymap('v', lhs, rhs, opts) end
function vnoremap(lhs, rhs, opts) set_keymap('v', lhs, rhs, { noremap = true }, opts) end
function vnoremap_local(rhs, lhs) vnoremap(lhs, rhs, { buffer = true }) end
function imap(lhs, rhs, opts) set_keymap('i', lhs, rhs, opts) end
function inoremap(lhs, rhs, opts) set_keymap('i', lhs, rhs, { noremap = true }, opts) end

