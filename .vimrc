" Use vim settings, not vi settings
set nocompatible

" Pathogen is amazing!
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Allow backspacing over everything
set backspace=indent,eol,start

" Some interface options
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set number              " line numbering
set showtabline=1       " show tab bar only when there is more than 1 tab
syntax on               " syntax highlighting
set hlsearch            " highlight last search

" Editing options
set expandtab           " use spaces, not tabs!
set tabstop=4           " indents are 4 spaces
set shiftwidth=4        " autoindent 4 spaces
set smarttab
set fdm=marker          " folding on   {{{ }}}
set textwidth=100       " try to keep lines to <= 100 chars
set formatoptions=rolqw

" Enable file type detection.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
    au!
    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif
augroup END

" Set a load of options when running GUI (gvim)
if has("gui_running")
    " Set font
    if has("win32")
        set guifont=Tamsyn6x11:h9:cOEM
    else
        set guifont=Dejavu\ Sans\ Mono\ 8
        "set guifont=Tamsyn\ 8
        "set guifont=termsyn\ 8
    endif

    " Override font for work machine with nicer monitors...
    if hostname() == 'arbeit'
        "set guifont=Inconsolata\ 10
    endif

    " Disable menubar and toolbar
    set guioptions-=m
    set guioptions-=T

    " Set colorscheme
    set background=dark
    "let g:solarized_italic=0
    "let g:solarized_hitrail=1
    "colorscheme solarized
    "colorscheme Tomorrow-Night
    colorscheme base16-tomorrow

    " Bind alt+number to tab switching
    map <M-1> 1gt
    map <M-2> 2gt
    map <M-3> 3gt
    map <M-4> 4gt
    map <M-5> 5gt
    map <M-6> 6gt
    map <M-7> 7gt
    map <M-8> 8gt
    map <M-9> 9gt
else
    "set t_Co=256
    set mouse=a         " Allow mouse interaction in terminals
    set ttymouse=xterm2 " Seems to stop mouse interaction breaking inside tmux
    set background=dark
    "let g:solarized_termcolors=256
    "colorscheme solarized
    "colorscheme Tomorrow-Night
    colorscheme base16-tomorrow
endif

" Highlight column 80 as a reminder, as long as it's supported
if exists('+colorcolumn')
    set colorcolumn=+1
endif


" key mappings

" Omnicomplete hotkey (INSERT mode)
imap <C-space> <C-x><C-o>
" save
map <C-s> :w<cr>
imap <C-s> <Esc>:w<cr>a
" vertical split tree explorer
map tt :NERDTreeToggle<cr>

" Fix Fortran editing
unlet! fortran_fixed_source
let fortran_free_source=1

" Configure NERDTree
let NERDTreeShowBookmarks = 1
let NERDTreeRespectWildIgnore = 1

" Globally hide certain files
set wildignore+=*.pyc,*.o,*.mod

" Tweak omni-complete
set completeopt+=menuone

" Mouse pointer never re-appears on recent Ubuntu versions =(
set nomousehide
