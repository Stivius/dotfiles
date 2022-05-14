require('common')

function ExecuteTodoCommand(opts, command)
	local first, last, args = opts['line1'], opts['line2'], opts['args'];
	local ids = {};
	for i = first, last do
		table.insert(ids, i);
	end
	local idsStr = table.concat(ids, ',');
	local manyPrefix = #ids > 1 and 'many' or '';
	local confirmCmd = opts['confirm'] and 'yes |' or '';
	local cmdFormat = string.format('!%s todo.sh %s %s %s %s', confirmCmd, manyPrefix, command, idsStr, args);
	print(cmdFormat)
	vim.cmd(string.format('silent exec "%s"', cmdFormat));
end

vim.api.nvim_create_user_command(
	'TodoPri',
	function(opts) ExecuteTodoCommand(opts, 'pri') end,
	{ nargs = 1, range = true }
)

vim.api.nvim_create_user_command(
	'TodoDepri',
	function(opts) ExecuteTodoCommand(opts, 'depri') end,
	{ nargs = 0, range = true }
)

vim.api.nvim_create_user_command(
	'TodoSchedule',
	function(opts) ExecuteTodoCommand(opts, 'schedule') end,
	{ nargs = 1, range = true }
)

vim.api.nvim_create_user_command(
	'TodoUnschedule',
	function(opts)
		opts['args'] = 'rm';
		ExecuteTodoCommand(opts, 'schedule');
	end,
	{ nargs = 0, range = true }
)

vim.api.nvim_create_user_command(
	'TodoDone',
	function(opts)
		opts['confirm'] = true;
		ExecuteTodoCommand(opts, 'done');
	end,
	{ nargs = 0, range = true }
)

vim.api.nvim_create_user_command(
	'TodoDel',
	function(opts)
		opts['confirm'] = true;
		ExecuteTodoCommand(opts, 'del');
	end,
	{ nargs = 0, range = true }
)

vim.api.nvim_create_user_command(
	'TodoDate',
	function(opts)
		local result = 't:' .. string.gsub(vim.fn.system('date --date ' .. opts['args'] .. ' +%Y-%m-%d'), '\n', '');
		opts['args'] = result;
		ExecuteTodoCommand(opts, 'append');
	end,
	{ nargs = 1, range = true }
)

nnoremap('<Leader>pa', ':TodoPri A<CR>')
nnoremap('<Leader>pb', ':TodoPri B<CR>')
nnoremap('<Leader>pc', ':TodoPri C<CR>')
nnoremap('<Leader>pd', ':TodoPri D<CR>')
nnoremap('<Leader>pp', ':TodoDepri<CR>')

-- generate date
-- revive
