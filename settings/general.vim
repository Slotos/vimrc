set nobackup
set noswapfile
set autoread
set autowrite
set confirm
set splitbelow
set browsedir=buffer
if has('vim_starting')
  set encoding=UTF-8
  scriptencoding UTF-8
endif
set mouse=a
set laststatus=2
set showtabline=2
set statusline=-        " hide file name in statusline
set fillchars+=vert:\|  " add a bar for vertical splits
set fillchars=eob:\           " hide ~
if has('mac')
  let g:clipboard = {
        \   'name': 'macOS-clipboard',
        \   'copy': {
        \      '+': 'pbcopy',
        \      '*': 'pbcopy',
        \    },
        \   'paste': {
        \      '+': 'pbpaste',
        \      '*': 'pbpaste',
        \   },
        \   'cache_enabled': 0,
        \ }
endif

if has('clipboard')
  set clipboard& clipboard+=unnamedplus
endif
set history=2000
set number
set timeout ttimeout
set cmdheight=2         " Height of the command line
set timeoutlen=500
set ttimeoutlen=10
set updatetime=100
set undofile
set relativenumber
set backspace=2
set backspace=indent,eol,start
set scrolloff=3
" Tabs and Indents {{{
" ----------------
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set autoindent
set smartindent
set shiftround
" }}}
set hidden
set shortmess=aFc
set signcolumn=yes
set completefunc=emoji#complete
set completeopt =longest,menu
set completeopt-=preview
set list
set listchars=tab:»·,nbsp:+,trail:·,extends:→,precedes:←

set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set hlsearch        " Highlight search results
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed
set grepprg=rg\ --vimgrep\ $*
set wildignore+=*.so,*~,*/.git/*,*/.svn/*,*/.DS_Store,*/tmp/*

if has('conceal')
  set conceallevel=3 concealcursor=niv
endif

" Vim Directories {{{
" ---------------
set undofile swapfile nobackup
set directory=$VIM_DATA_DIR/swap/
set undodir=$VIM_DATA_DIR/undo/
set backupdir=$VIM_DATA_DIR/backup/
set viewdir=$VIM_DATA_DIR/view/
set nospell spellfile=$VIM_PATH/spell/en.utf-8.add

" History saving
set history=1000
if has('nvim')
  set shada='300,<50,@100,s10,h
else
  set viminfo='300,<10,@50,h,n$VIM_DATA_DIR/viminfo
endif

" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)

  set noswapfile
  set nobackup
  set nowritebackup
  set noundofile
  if has('nvim')
    set shada="NONE"
  else
    set viminfo="NONE"
  endif
endif

" Secure sensitive information, disable backup files in temp directories
if exists('&backupskip')
  set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
  set backupskip+=.vault.vim
endif

" Disable swap/undo/viminfo/shada files in temp directories or shm
augroup MyAutoCmd
  silent! autocmd BufNewFile,BufReadPre
        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
        \ setlocal noswapfile noundofile nobackup nowritebackup viminfo= shada=
augroup END

if has('folding')
  set foldenable
  set foldmethod=syntax
  set foldlevelstart=99
endif

" netrw defaults
let g:netrw_preview   = 1
let g:netrw_liststyle = 3
let g:netrw_winsize   = 30

" nvim sometimes provides an empty flag
" CocTagFunc skips lookup if flag is not 'c'
" This is a crude patch around it
function! GotoTag(pattern, flags, info) abort
  if a:flags ==# ''
    return CocTagFunc(a:pattern, 'c', a:info)
  else
    return CocTagFunc(a:pattern, a:flags, a:info)
  endif
endfunction

set tagfunc=GotoTag
