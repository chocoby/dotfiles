set nocompatible    " vi 互換を使用しない

" 表示系
" --------------------
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

" ステータスバーに文字コード/改行コードを表示
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" 基本設定
" --------------------
" タブ
set tabstop=4       " 半角スペース4つ分
set expandtab       " タブを半角スペースにする
set smarttab        " 行頭の余白内でタブを入力すると shiftwidth の数だけインデントする
set shiftwidth=4    " 行頭の余白内でタブを入力すると4つ分追加される
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
set clipboard+=unnamed          " OS のクリップボードを使用する
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

" キーマップ
" F4 は QuickBuf
" --------------------
" スペースキーでカーソルを中心に保ってスクロール
nnoremap <Space> jzz
nnoremap <S-Space> kzz
" ESC キー2回押しでハイライトを消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>
nmap <F2> :NERDTreeToggle<CR><ESC>
nmap <F3> :Tlist<CR><ESC>
nmap <F5> gT
nmap <F6> gt
nmap f :e<Space>
nmap t :tabnew<Space>

" 文字コード
" --------------------
" 文字コードの自動認識
" 参照：http://www.kawaz.jp/pukiwiki/?vim#cb691f26
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif

if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconvがeucJP-msに対応しているかをチェック
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX0213に対応しているかをチェック
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    " fileencodingsを構築
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif
    " 定数を処分
    unlet s:enc_euc
    unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" お役立ち
" --------------------
" 対応したカッコを補完し、カッコの中にカーソルを戻す
imap { {}<Left>
imap [ []<Left>
imap ( ()<Left>
imap < <><Left>
" カッコの中にカーソルを戻す
imap '' ''<Left>
imap "" ""<Left>
imap `` ``<Left>

" 行末の不要なスペースを削除
function! RTrim()
    let s:cursor = getpos(".")
    %s/\s\+$//e
    call setpos(".", s:cursor)
endfunction
autocmd BufWritePre * call RTrim()

" プラグイン
" --------------------
" vim-pathogen
filetype off
filetype indent off
syntax off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
set helpfile=$VIMRUNTIME/doc/help.txt
filetype plugin indent on
syntax on
" neocomplcache
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
" surround
let g:surround_{char2nr("b")} = "{% block\1 \r..*\r &\1%}\r{% endblock %}"
let g:surround_{char2nr("i")} = "{% if\1 \r..*\r &\1%}\r{% endif %}"
let g:surround_{char2nr("w")} = "{% with\1 \r..*\r &\1%}\r{% endwith %}"
let g:surround_{char2nr("c")} = "{% comment\1 \r..*\r &\1%}\r{% endcomment %}"
let g:surround_{char2nr("f")} = "{% for\1 \r..*\r &\1%}\r{% endfor %}"
" ctrlp.vim
" 無視するファイル
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so     " Linux/MacOSX
set wildignore+=.git\*,.hg\*,.svn\*,*.dll,*.exe    " Windows
