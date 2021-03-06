require('common')

vim.opt_local.complete:append('k')
vim.opt_local.dictionary:append('$HOME/.todo/projects.txt')
vim.opt_local.dictionary:append('$HOME/.todo/contexts.txt')
vim.opt_local.iskeyword:append('-')

vim.cmd([[
	autocmd BufWritePost * silent !todo.sh lsprj > $HOME/.todo/projects.txt && todo.sh lsc > $HOME/.todo/contexts.txt
]])

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

create_user_command(
	'TodoPri',
	function(opts) ExecuteTodoCommand(opts, 'pri') end,
	{ nargs = 1, range = true, buffer = true }
)

create_user_command(
	'TodoDepri',
	function(opts) ExecuteTodoCommand(opts, 'depri') end,
	{ nargs = 0, range = true, buffer = true }
)

create_user_command(
	'TodoSchedule',
	function(opts) ExecuteTodoCommand(opts, 'schedule') end,
	{ nargs = 1, range = true, buffer = true }
)

create_user_command(
	'TodoUnschedule',
	function(opts)
		opts['args'] = 'rm';
		ExecuteTodoCommand(opts, 'schedule');
	end,
	{ nargs = 0, range = true, buffer = true }
)

create_user_command(
	'TodoDone',
	function(opts)
		opts['confirm'] = true;
		ExecuteTodoCommand(opts, 'done');
	end,
	{ nargs = 0, range = true, buffer = true }
)

create_user_command(
	'TodoRevive',
	function(opts)
		ExecuteTodoCommand(opts, 'revive');
	end,
	{ nargs = 0, range = true, buffer = true }
)

create_user_command(
	'TodoDel',
	function(opts)
		opts['confirm'] = true;
		ExecuteTodoCommand(opts, 'del');
	end,
	{ nargs = 0, range = true, buffer = true }
)

create_user_command(
	'TodoWeekly',
	function(opts)
		opts['args'] = 'goals:Weekly';
		ExecuteTodoCommand(opts, 'append');
	end,
	{ nargs = 0, range = true, buffer = true }
)

create_user_command(
	'TodoMonthly',
	function(opts)
		opts['args'] = 'goals:Monthly';
		ExecuteTodoCommand(opts, 'append');
	end,
	{ nargs = 0, range = true, buffer = true }
)

-- priority
nnoremap_local('<Leader><Leader>pa', ':TodoPri A<CR>')
vnoremap_local('<Leader><Leader>pa', ':TodoPri A<CR>')
nnoremap_local('<Leader><Leader>pb', ':TodoPri B<CR>')
vnoremap_local('<Leader><Leader>pb', ':TodoPri B<CR>')
nnoremap_local('<Leader><Leader>pc', ':TodoPri C<CR>')
vnoremap_local('<Leader><Leader>pc', ':TodoPri C<CR>')
nnoremap_local('<Leader><Leader>pd', ':TodoPri D<CR>')
vnoremap_local('<Leader><Leader>pd', ':TodoPri D<CR>')
nnoremap_local('<Leader><Leader>pp', ':TodoDepri<CR>')
vnoremap_local('<Leader><Leader>pp', ':TodoDepri<CR>')

-- goals
nnoremap_local('<Leader><Leader>gw', ':TodoWeekly<CR>')
vnoremap_local('<Leader><Leader>gw', ':TodoWeekly<CR>')
nnoremap_local('<Leader><Leader>gm', ':TodoMonthly<CR>')
vnoremap_local('<Leader><Leader>gm', ':TodoMonthly<CR>')

-- schedule
nnoremap_local('<Leader><Leader>srm', ':TodoUnschedule<CR>')
vnoremap_local('<Leader><Leader>srm', ':TodoUnschedule<CR>')
nnoremap_local('<Leader><Leader>ss', ':TodoSchedule ')
vnoremap_local('<Leader><Leader>ss', ':TodoSchedule ')
nnoremap_local('<Leader><Leader>stt', ':TodoSchedule today<CR>')
vnoremap_local('<Leader><Leader>stt', ':TodoSchedule today<CR>')
nnoremap_local('<Leader><Leader>stm', ':TodoSchedule tomorrow<CR>')
vnoremap_local('<Leader><Leader>stm', ':TodoSchedule tomorrow<CR>')
nnoremap_local('<Leader><Leader>stw', ':TodoSchedule +1 week<CR>')
vnoremap_local('<Leader><Leader>stw', ':TodoSchedule +1 week<CR>')

-- deletion/finish
nnoremap_local('<Leader><Leader>od', ':vsp ~/.todo/done.txt<CR>')
nnoremap_local('<Leader><Leader>d', ':TodoDone<CR>')
vnoremap_local('<Leader><Leader>d', ':TodoDone<CR>')
nnoremap_local('<Leader><Leader>rv', ':TodoRevive<CR>')
vnoremap_local('<Leader><Leader>rv', ':TodoRevive<CR>')
nnoremap_local('<Leader><Leader>rm', ':TodoDel<CR>')
vnoremap_local('<Leader><Leader>rm', ':TodoDel<CR>')
