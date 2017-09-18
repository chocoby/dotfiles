nnoremap <silent> <C-p> :<C-u>Denite file_rec<CR>
nnoremap <silent> ,,y :<C-u>Denite neoyank<CR>

call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

call denite#custom#source('file_rec', 'matchers', ['matcher_fuzzy','matcher_ignore_globs'])
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [
      \ '.git/', 'tmp/', '.bundle/',
      \ 'node_modules/', '.sass-cache/',
      \ 'coverage/','.DS_Store' ])
