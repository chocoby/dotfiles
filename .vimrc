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
set cursorline      " カーソル行をハイライト
set showmatch       " 対応する括弧の表示
set matchtime=1
set pumheight=10
set colorcolumn=81  " 81 桁目をハイライト

syntax on           " カラーハイライト

" ステータスバーに文字コード/改行コードを表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

colorscheme jellybeans

"--------------------------------------
" 基本設定
"--------------------------------------
" タブ
set tabstop=4       " 半角スペース 4 つ分
set expandtab       " タブを半角スペースにする
set smarttab        " 行頭の余白内でタブを入力すると shiftwidth の数だけインデントする
set shiftwidth=4    " 行頭の余白内でタブを入力すると 4 つ分追加される
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

"--------------------------------------
" キーマップ
"--------------------------------------
" スペースキーでカーソルを中心に保ってスクロール
nnoremap <Space> jzz

inoremap <C-c> <Esc>

" ESC キー2回押しでハイライトを消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>

nmap <F3> :VimFiler<CR><ESC>
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
" grep に ag を使う
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup --hidden'
let g:unite_source_grep_max_candidates = 1000

" prefix key
nnoremap [unite] <Nop>
nmap <S-f> [unite]

" basic key mappings
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
nnoremap <silent> [unite]s :<C-u>Unite source<CR>
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>

" unite-rails
nnoremap <silent> [unite]r :<C-u>Unite rails/
nnoremap <silent> [unite]rmo :<C-u>Unite rails/model<CR>
nnoremap <silent> [unite]rcon :<C-u>Unite rails/controller<CR>
nnoremap <silent> [unite]rvi :<C-u>Unite rails/view<CR>
nnoremap <silent> [unite]rhel :<C-u>Unite rails/helper<CR>
nnoremap <silent> [unite]rlib :<C-u>Unite rails/lib<CR>
nnoremap <silent> [unite]rdb :<C-u>Unite rails/db<CR>
nnoremap <silent> [unite]rconfig :<C-u>Unite rails/config<CR>
nnoremap <silent> [unite]rlog :<C-u>Unite rails/log<CR>
nnoremap <silent> [unite]rspe :<C-u>Unite rails/spec<CR>

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
" スニペット補完
" スニペットファイルの置き場所
let g:neosnippet#snippets_directory = '~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

"--------------------------------------
" VimFiler
"--------------------------------------
" セーフモードを無効にする
let g:vimfiler_safe_mode_by_default = 0

" カレントディレクトリの絞り込みに unite.vim を使う
function! UniteFileCurrentDir()
  let s  = ':Unite file -start-insert -path='
  let s .= vimfiler#get_current_vimfiler().current_dir

  execute s
endfunction

autocmd FileType vimfiler
      \ nnoremap <buffer><silent>/
      \ :call UniteFileCurrentDir() <CR>


"--------------------------------------
" ctrlp.vim
"--------------------------------------
" 無視するファイル
" Linux/Mac OS X
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*/node_modules/*,*/coverage/*

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
" vundle
"--------------------------------------
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

Plugin 'gmarik/vundle'

" GitHub/vim-scripts
Plugin 'taglist.vim'
Plugin 'quickrun.vim'

" GitHub
Plugin 'Shougo/neocomplcache'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'Shougo/vimproc'
Plugin 'Shougo/vimshell'
Plugin 'Shougo/vimfiler'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/tabpagebuffer.vim'
Plugin 'Shougo/unite-outline'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'scrooloose/nerdcommenter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'kchmck/vim-coffee-script'
Plugin 'groenewege/vim-less'
Plugin 'thinca/vim-qfreplace'
Plugin 'nanotech/jellybeans.vim'
Plugin 'basyura/unite-rails'
Plugin 'hallison/vim-markdown'
Plugin 'vim-ruby/vim-ruby'
Plugin 'kana/vim-operator-user'
Plugin 'kana/vim-operator-replace'
Plugin 'jnwhiteh/vim-golang'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'junegunn/vim-easy-align'
Plugin 'banyan/recognize_charcode.vim'
Plugin 'cohama/lexima.vim'
Plugin 'AndrewRadev/switch.vim'
Plugin 'bkad/CamelCaseMotion'
Plugin 'chase/vim-ansible-yaml'

call vundle#end()
filetype plugin indent on
