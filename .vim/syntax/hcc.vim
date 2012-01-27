" Vim syntax file
" Language:	Handel-C
" Maintainer:	Andreas Fidjeland
" Last Change:	2005 January
" Extends the standard C syntax with Handel-C keywords

:runtime! syntax/c.vim
:unlet b:current_syntax
:set cindent

syn match cChannel /?/
syn match cChannel /!/

syn keyword cType part family
syn keyword cType undefined signal 
syn keyword cType clock external external_divide internal internal_divide 
syn keyword cType ram rom mpram wom interface sema
syn keyword cType chan channel chanin chanout 

syn keyword cLabel macro proc expr ifselect select 
syn keyword cLabel let with shared inline
syn keyword cLabel par seq try reset set prialt

syn keyword cStatement delay width assert trysema releasesema typeof intwidth 
