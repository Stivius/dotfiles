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
syntax  match  TodoPriorityA  '^([aA])\s.\+$'             contains=TodoDate,TodoProject,TodoContext,OverDueDate
syntax  match  TodoPriorityB  '^([bB])\s.\+$'             contains=TodoDate,TodoProject,TodoContext,OverDueDate
syntax  match  TodoPriorityC  '^([cC])\s.\+$'             contains=TodoDate,TodoProject,TodoContext,OverDueDate
syntax  match  TodoPriorityD  '^([dD])\s.\+$'             contains=TodoDate,TodoProject,TodoContext,OverDueDate

syntax  match  TodoDate       '\d\{2,4\}-\d\{2\}-\d\{2\}' contains=NONE
syntax  match  TodoProject    '\(^\|\W\)+[^[:blank:]]\+'  contains=NONE
syntax  match  TodoContext    '\(^\|\W\)@[^[:blank:]]\+'  contains=NONE

" Other priority colours might be defined by the user
highlight  TodoDone       ctermfg=LightGray guifg=LightGray
highlight  TodoPriorityA  ctermfg=Yellow guifg=Yellow
highlight  TodoPriorityB  ctermfg=Green guifg=Green
highlight  TodoPriorityC  ctermfg=LightBlue guifg=LightBlue
highlight  TodoDate       ctermfg=Blue guifg=Blue
highlight  TodoProject    ctermfg=Red guifg=Red
highlight  TodoContext    ctermfg=Red guifg=Red

let b:current_syntax = "todo"

