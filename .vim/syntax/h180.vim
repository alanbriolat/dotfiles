" Vim syntax file
" Language:     h180 Assembler
" Maintainer:   Alan Briolat <alan@codescape.net>
" Last Change:  2008 Jan 30

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax case match

syntax match PreProc            "\.[a-z]*"
"syntax match Define             "[0-9a-zA-Z_\-]\+="
syntax match Comment            "#.*"
syntax match Constant           "\<\d\+\>"
syntax match Constant           "0x[0-9a-f]\{2,4\}"
syntax match Constant           "'.'"
syntax match Label              "[0-9a-zA-Z_\-]\+\:"
syntax match Label              "[0-9][fb]"
syntax match Operator           "[()+\-*~%|&><\[\]]"
syntax match Delimiter          "[,]"
syntax keyword Underlined       a b c d e f h l af bc de hl sp ix iy i
syntax keyword Function         add adc and cp cpl dec inc mlt neg or sub
                            \   sbc tst xor rl rla rlc rlca rr rra rrc rrca
                            \   rld rrd sla sra srl set res bit ld cpd cpdr
                            \   cpi cpir ldd lddr ldi ldir push pop ex exx
                            \   call djnz jp jr ret reti retn rst in in0
                            \   ind indr ini inir out out0 otdm otdmr otdr
                            \   outi otir tstio otim otimr outd daa ccf scf
                            \   di ei halt im nop slp
syntax keyword Conditional      z nz c nc
"syntax keyword Underlined       call djnz jp jr ret reti retn

let b:current_syntax = "h180"
