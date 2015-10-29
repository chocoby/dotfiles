" カラースキーム
colorscheme jellybeans
" フォント設定
if has('gui_macvim')
    set guifont=DejaVu\ Sans\ Mono:h16
else
    set guifont=DejaVu\ Sans\ Mono\ 12
endif
" カーソルを点滅させない
set guicursor=a:blinkon0

" コマンドモードに戻るときに IME をオフ
" 日本語を入力していると半角英数字に切り替わる問題の対応
set imdisable
