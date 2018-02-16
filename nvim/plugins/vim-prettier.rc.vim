let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx PrettierAsync
