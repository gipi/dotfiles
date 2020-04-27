syntax on
set exrc
filetype plugin on
set hls
set listchars=tab:.\ ,eol:$
" unicode 2026
set showbreak=...
set list
set laststatus=2
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

" pathogen
call pathogen#infect()

" Python stuffs primarly
set expandtab
let g:netrw_ftp_cmd = "lftp"

set sw=4
set ts=4
set sts=4
set smartindent
set smartcase
set number
set foldmethod=indent

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

" Arduino related stuffs
" From https://github.com/GrayHats/arduino_scripts
autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino

" gruvbox colorscheme <https://github.com/morhetz/gruvbox/wiki/Usage>
colorscheme lucario
set background=dark    " Setting dark mode
" airline
" let g:airline_powerline_fonts = 1
"if !exists('g:airline_symbols')
"  let g:airline_symbols = {}
"endif
"let g:airline_symbols.space = "\ua0"

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

  " unicode symbols
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'
  let g:airline_symbols.crypt = 'ð'
  let g:airline_symbols.linenr = '☰'
  let g:airline_symbols.linenr = '␊'
  let g:airline_symbols.linenr = '␤'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.maxlinenr = '㏑'
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.paste = 'Þ'
  let g:airline_symbols.paste = '∥'
  let g:airline_symbols.spell = 'Ꞩ'
  let g:airline_symbols.notexists = 'Ɇ'
  let g:airline_symbols.whitespace = 'Ξ'
