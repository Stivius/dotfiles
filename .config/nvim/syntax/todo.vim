" File:        todo.txt.vim
" Description: Todo.txt syntax settings
" Author:      Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/freitass/todo.txt-vim
" Version:     0.3

if exists("b:current_syntax")
    finish
endif

syntax  match  TodoDone       '^[xX]\s.\+$'
syntax  match  TodoPriorityA  '^([aA])\s.\+$'             contains=TodoDate,TodoProject,TodoContext,OverDueDate,TodoMeta
syntax  match  TodoPriorityB  '^([bB])\s.\+$'             contains=TodoDate,TodoProject,TodoContext,OverDueDate,TodoMeta
syntax  match  TodoPriorityC  '^([cC])\s.\+$'             contains=TodoDate,TodoProject,TodoContext,OverDueDate,TodoMeta
syntax  match  TodoPriorityD  '^([dD])\s.\+$'             contains=TodoDate,TodoProject,TodoContext,OverDueDate,TodoMeta

syntax  match  TodoMeta       '\(^\|\W\)\w\+\:[^[:blank:]]\+' 	contains=NONE
syntax  match  TodoDate       '\d\{2,4\}-\d\{2\}-\d\{2\}' 		contains=NONE
syntax  match  TodoProject    '\(^\|\W\)+[^[:blank:]]\+'  		contains=NONE
syntax  match  TodoContext    '\(^\|\W\)@[^[:blank:]]\+'  		contains=NONE

highlight  TodoDate       ctermfg=Blue guifg=#6A9FB5
highlight  TodoDone       ctermfg=LightGray guifg=#505050
highlight  TodoPriorityA  ctermfg=Yellow cterm=bold guifg=#F4BF75 gui=bold
highlight  TodoPriorityB  ctermfg=Green guifg=#90A959
highlight  TodoPriorityC  ctermfg=LightBlue cterm=bold guifg=#6A9FB5 gui=bold
highlight  TodoProject    ctermfg=Red guifg=#AC4142
highlight  TodoContext    ctermfg=Red guifg=#AC4142
highlight  TodoMeta       ctermfg=Cyan guifg=#75B5AA

let b:current_syntax = "todo"

