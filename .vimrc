set nocompatible    " vi 互換を使用しない

"--------------------------------------
" 見た目
"--------------------------------------
set number          " 行番号表示
set ruler           " ステータスバーにルーラー表示
set laststatus=2    " ステータスバー表示
set cmdheight=2     " コマンドバー調整
set title           " タイトルバー
set linespace=0     " 行間
set wildmenu        " 補完強化
set showcmd         " コマンドライン補完を表示
set showtabline=2   " タブバーの表示
set showmatch       " 対応する括弧の表示
set matchtime=1
set pumheight=10

syntax on           " カラーハイライト

" ステータスバーに文字コード/改行コードを表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set statusline+=%#warningmsg#
set statusline+=%*

try
  colorscheme jellybeans
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme desert
endtry

"--------------------------------------
" 基本設定
"--------------------------------------
" タブ
set tabstop=2       " 半角スペース 2 つ分
set expandtab       " タブを半角スペースにする
set smarttab        " 行頭の余白内でタブを入力すると shiftwidth の数だけインデントする
set shiftwidth=2    " 行頭の余白内でタブを入力すると 2 つ分追加される
set shiftround      " shiftwidth で設定された整数倍のスペースが追加される
set nowrap          " 折り返し表示をしない

" 検索
set ignorecase      " 大文字小文字の無視
set smartcase       " 検索語句に大文字を含んでいたら区別する
set wrapscan        " 最後まで検索したら先頭へ戻る
set hlsearch        " 検索文字列をハイライト
set incsearch       " インクリメンタルサーチ

" インデント
set autoindent      " 自動インデント
set smartindent     " より高度な自動インデント
set cindent         " C 言語の自動インデント

" 編集
set hidden          " 編集中でも他のファイルを開けるようにする
set whichwrap=b,s,h,l,<,>,[,]   " カーソルを行頭、行末で止まらないようにする
set backspace=indent,eol,start  " 改行して自動インデントされたスペースを BS で削除
set clipboard=unnamed           " yank は OS のクリップボードを使用する

" Insert Mode を抜けたら IME をオフにする
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

" バックアップ
set backup
set backupdir=~/.vim_backup
set swapfile
set directory=~/.vim_swap
set noundofile

set wildignore+=*/.git/*,*/.bundle/*,*/node_modules/*,*/coverage/*,*/tmp/*

"--------------------------------------
" キーマップ
"--------------------------------------
" スペースキーでカーソルを中心に保ってスクロール
nnoremap <Space> jzz

inoremap <C-c> <Esc>

" ESC キー2回押しでハイライトを消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>

nmap <F3> :VimFiler -status -fnamewidth=100 -simple<CR><ESC>
nmap <F4> :Unite buffer<CR><ESC>
nmap <F5> gT
nmap <F6> gt
nmap <F11> <C-w>_
nmap <F12> <C-w>=
nmap t :tabnew<Space>
nmap T :tabclose
nnoremap Y y$
nnoremap Q <Nop>
map <C-w><C-w> <ESC>:w<CR>

imap <C-h> <BS>
cmap <C-h> <BS>

set pastetoggle=<F10>

"--------------------------------------
" 便利
"--------------------------------------
" 行末の不要なスペースを削除
function! RTrim()
  let s:cursor = getpos(".")
  %s/\s\+$//e
  call setpos(".", s:cursor)
endfunction
autocmd BufWritePre * call RTrim()

"--------------------------------------
" unite.vim
"--------------------------------------
let g:unite_source_grep_command       = 'ag'
let g:unite_source_grep_default_opts  = '-i --nogroup --nocolor --hidden'
let g:unite_source_grep_encoding      = 'utf-8'
let g:unite_source_grep_recursive_opt = ''

" prefix key
nnoremap [unite] <Nop>
nmap <S-f> [unite]

" basic key mappings
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
nnoremap <silent> [unite]s :<C-u>Unite source<CR>
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>

"--------------------------------------
" neocomplcache
"--------------------------------------
" vim 起動時に有効化
let g:neocomplcache_enable_at_startup = 1
" 大文字が入力されるまで大文字小文字を区別しない
let g:neocomplcache_enable_smart_case = 1
" _ 区切りの補完を有効化
let g:neocomplcache_enable_underbar_completion = 1
" 日本語は補完しない
" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
"--------------------------------------
" VimFiler
"--------------------------------------
let g:vimfiler_safe_mode_by_default = 0

" カレントディレクトリの絞り込みに unite.vim を使う
function! UniteFileCurrentDir()
  let s  = ':Unite file -start-insert -path='
  let s .= vimfiler#helper#_get_file_directory()

  execute s
endfunction

autocmd FileType vimfiler
      \ nnoremap <buffer><silent>/
      \ :call UniteFileCurrentDir() <CR>


"--------------------------------------
" ctrlp.vim
"--------------------------------------
let g:ctrlp_match_func = { 'match' : 'ctrlp_matchfuzzy#matcher' }
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"--------------------------------------
" vim-easymotion
"--------------------------------------
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

nmap f <Plug>(easymotion-w)
nmap r <Plug>(easymotion-b)
map J <Plug>(easymotion-j)
map K <Plug>(easymotion-k)

"--------------------------------------
" vim-operator-replace
"--------------------------------------
map R <Plug>(operator-replace)

"--------------------------------------
" vim-easy-align
"--------------------------------------
vmap <Enter> <Plug>(EasyAlign)

"--------------------------------------
" CamelCaseMotion
"--------------------------------------
map <S-W> <Plug>CamelCaseMotion_w
map <S-B> <Plug>CamelCaseMotion_b
map <S-E> <Plug>CamelCaseMotion_e

"--------------------------------------
" incsearch.vim
"--------------------------------------
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

"--------------------------------------
" vim-plug
"--------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'Shougo/neocomplcache'
Plug 'Shougo/vimproc', { 'do': 'make' }
Plug 'Shougo/vimfiler'
Plug 'Shougo/unite.vim'
Plug 'Shougo/tabpagebuffer.vim'
Plug 'Shougo/unite-outline'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-matchfuzzy'
Plug 'Lokaltog/vim-easymotion'
Plug 'thinca/vim-qfreplace'
Plug 'nanotech/jellybeans.vim'
Plug 'vim-ruby/vim-ruby'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-operator-replace'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'junegunn/vim-easy-align'
Plug 'banyan/recognize_charcode.vim'
Plug 'cohama/lexima.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'bkad/CamelCaseMotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'sheerun/vim-polyglot'

call plug#end()
