set number
set ruler
set showmatch

set title
set linespace=0
set wildmenu
set showcmd
set showtabline=2
set matchtime=1
set pumheight=10

set lazyredraw

set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']'}%=%l,%c%V%8P
set statusline+=%*

" tab
set tabstop=2
set expandtab
set smarttab
set shiftwidth=2
set shiftround
set nowrap

" search
set ignorecase
set smartcase
set wrapscan
set hlsearch
set incsearch

" indent
set autoindent
set smartindent
set cindent

" edit
set hidden
set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start
set clipboard+=unnamedplus

" backup
set backup
set backupdir=~/.vim_backup
set swapfile
set directory=~/.vim_swap
set noundofile

" Remove trailing spaces
function! RTrim()
  let s:cursor = getpos(".")
  %s/\s\+$//e
  call setpos(".", s:cursor)
endfunction
autocmd BufWritePre * call RTrim()
