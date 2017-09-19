nnoremap [denite] <Nop>
nmap <S-f> [denite]

nnoremap <silent> <F4> :<C-u>Denite buffer<CR>
nnoremap <silent> <C-p> :<C-u>Denite file_rec<CR>
nnoremap <silent> [denite]t :<C-u>Denite unite:tab<CR>
nnoremap <silent> [denite]y :<C-u>Denite neoyank<CR>
nnoremap <silent> [denite]g :<C-u>Denite grep -buffer-name=search-buffer-denite<CR>
nnoremap <silent> [denite]r :<C-u>Denite -resume -buffer-name=search-buffer-denite<CR>

call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-f>', '<denite:scroll_page_forwards>', 'noremap')
call denite#custom#map('insert', '<C-b>', '<denite:scroll_page_backwards>', 'noremap')

call denite#custom#source('file_rec', 'matchers', ['matcher_fuzzy', 'matcher_ignore_globs'])
call denite#custom#var('file_rec', 'command',
      \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [
      \ '.git/', 'tmp/', '.bundle/',
      \ 'node_modules/', '.sass-cache/',
      \ 'coverage/', '.vagrant/',
      \ '.DS_Store' ])

call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
