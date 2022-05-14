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
	'TodoRevive',
	function(opts)
		ExecuteTodoCommand(opts, 'revive');
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

nnoremap('<Leader><Leader>pa', ':TodoPri A<CR>')
vnoremap('<Leader><Leader>pa', ':TodoPri A<CR>')
nnoremap('<Leader><Leader>pb', ':TodoPri B<CR>')
vnoremap('<Leader><Leader>pb', ':TodoPri B<CR>')
nnoremap('<Leader><Leader>pc', ':TodoPri C<CR>')
vnoremap('<Leader><Leader>pc', ':TodoPri C<CR>')
nnoremap('<Leader><Leader>pd', ':TodoPri D<CR>')
vnoremap('<Leader><Leader>pd', ':TodoPri D<CR>')
nnoremap('<Leader><Leader>pp', ':TodoDepri<CR>')
vnoremap('<Leader><Leader>pp', ':TodoDepri<CR>')

nnoremap('<Leader><Leader>srm', ':TodoUnschedule<CR>')
vnoremap('<Leader><Leader>srm', ':TodoUnschedule<CR>')
nnoremap('<Leader><Leader>ss', ':TodoSchedule ')
vnoremap('<Leader><Leader>ss', ':TodoSchedule ')
nnoremap('<Leader><Leader>stt', ':TodoSchedule today<CR>')
vnoremap('<Leader><Leader>stt', ':TodoSchedule today<CR>')
nnoremap('<Leader><Leader>stm', ':TodoSchedule tomorrow<CR>')
vnoremap('<Leader><Leader>stm', ':TodoSchedule tomorrow<CR>')

nnoremap('<Leader><Leader>od', ':vsp ~/.todo/done.txt<CR>')
nnoremap('<Leader><Leader>d', ':TodoDone<CR>')
vnoremap('<Leader><Leader>d', ':TodoDone<CR>')
nnoremap('<Leader><Leader>rv', ':TodoRevive<CR>')
vnoremap('<Leader><Leader>rv', ':TodoRevive<CR>')
nnoremap('<Leader><Leader>rm', ':TodoDel<CR>')
vnoremap('<Leader><Leader>rm', ':TodoDel<CR>')

