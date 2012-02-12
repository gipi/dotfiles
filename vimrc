syntax on
set exrc
filetype plugin on
set hls
set listchars=tab:▸\ ,eol:¬
" unicode 2026
set showbreak=…
set list

" Python stuffs primarly
set noexpandtab
let g:netrw_ftp_cmd = "lftp"

set sw=4
set ts=4
set sts=4

set mouse=a


"
" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
