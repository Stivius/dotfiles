function merge(first_table, second_table)
	for k,v in pairs(second_table) do first_table[k] = v end
	return first_table
end

function set_keymap(mode, lhs, rhs, opts, additional_opts)
	opts = opts or {}
	additional_opts = additional_opts or {}
	vim.api.nvim_set_keymap(mode, lhs, rhs, merge(opts, additional_opts))
end

function map(lhs, rhs, opts) set_keymap('', lhs, rhs, opts) end
function noremap(lhs, rhs, opts) set_keymap('', lhs, rhs, { noremap = true }, opts) end
function nmap(lhs, rhs, opts) set_keymap('n', lhs, rhs, opts) end
function nnoremap(lhs, rhs, opts) set_keymap('n', lhs, rhs, { noremap = true }, opts) end
function vmap(lhs, rhs, opts) set_keymap('v', lhs, rhs, opts) end
function vnoremap(lhs, rhs, opts) set_keymap('v', lhs, rhs, { noremap = true }, opts) end
function imap(lhs, rhs, opts) set_keymap('i', lhs, rhs, opts) end
function inoremap(lhs, rhs, opts) set_keymap('i', lhs, rhs, { noremap = true }, opts) end

