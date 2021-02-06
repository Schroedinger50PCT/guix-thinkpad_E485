set runtimepath=~/.guix-profile/share/vim/vimfiles
let g:airline_powerline_fonts = 1
"let g:vimtex_version_check = 0  
"let g:tex_flavor = 'latex'
"let g:vimtex_view_general_viewer = 'zathura'
"let g:vimtex_view = 'automatic'
"let g:vimtex_compiler_method = 'tectonic'
function! LF()
    let temp = tempname()
    exec 'silent !lf -selection-path=' . shellescape(temp)
    if !filereadable(temp)
        redraw!
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        return
    endif
    exec 'edit ' . fnameescape(names[0])
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction
command! -bar LF call LF()
set laststatus=2
set t_Co=256
set encoding=utf-8
set noshowmode
set number
set softtabstop=4
set expandtab
set wildmenu
set lazyredraw
set incsearch
set hlsearch
set autoindent
set smartindent
set smarttab
set backspace=indent,eol,start
set nocompatible
set ruler
set undolevels=1000
set foldenable
set foldmethod=syntax
set background=dark
map <C-c> "+y<CR>
