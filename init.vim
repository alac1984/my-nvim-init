" Vundle settings
set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'preservim/nerdtree'
Plugin 'Dimercel/todo-vim'
Plugin 'DavidEGx/ctrlp-smarttabs'
Plugin 'tpope/vim-commentary'
Plugin 'morhetz/gruvbox'
Plugin 'yuki-uthman/nvim-vimpad'
Plugin 'farfanoide/vim-kivy'
" ...

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Flagging whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" My personal basic settings
set encoding=utf-8
set clipboard=unnamedplus
set nowrap
set nu
nnoremap <SPACE> <Nop>
let mapleader=" "

" PEP 8 indentation
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Indentation for js, html and css files
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

" Indentation for .vim files
au BufNewFile,BufRead *.vim
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

" Basic global indentation
set foldmethod=indent
set foldlevel=99

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_semantic_triggers = {
	\   'python': [ 're!\w{2}' ]
	\ }
let g:ycm_auto_hover=''
set completeopt-=preview

" python with virtualenv support
python3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  exec(open(activate_this).read(), {'__file__': activate_this})
EOF

" pretty python code
let python_highlight_all=1
syntax on

" 256 colors, theme and transparent background
set t_Co=256
let g:gruvbox_italic=1
colorscheme gruvbox
hi Normal guibg=NONE ctermbg=NONE

" NERDTree
nnoremap <C-f> :NERDTreeToggle<CR>
vnoremap ++ <plug>NERDCommenterToggle
nnoremap ++ <plug>NERDCommenterToggle

" Airline
let g:airline_theme='gruvbox'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts = 1

" TODOToggle
nnoremap <F5> :TODOToggle<CR>

" Remaping the dangerous K command
nnoremap K :set wrap!<CR>

" Pylint
let g:syntastic_python_pylint_args = '--rcfile=/home/andre/.pylintrc'

" CtrlP Smart Tabs
let g:ctrlp_extensions = ['smarttabs']
nnoremap <C-,> :CtrlPSmartTabs<CR>

let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" nvim-vimpad
nmap <leader>t <Plug>(vimpad-toggle)
let g:vimpad_prefix = "\u2713"
let g:vimpad_suffix = ''
" let g:vimpad_add_padding = 1

" Defining your own colors
" for terminal
" ctermfg as the font golor
" ctermbg as the background color
highlight VimpadOutput      ctermfg=LightCyan    ctermbg=DarkBlue
highlight VimpadOutputError ctermfg=LightMagenta ctermbg=DarkMagenta

" for gui
" guifg as the font golor
" guibg as the background color
highlight VimpadOutput      guifg=LightCyan    guibg=DarkBlue
highlight VimpadOutputError guifg=LightMagenta guibg=DarkMagenta

" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

" Toggle terminal on/off (neovim)
nnoremap <silent><A-t> :call TermToggle(12)<CR>
inoremap <silent><A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <silent><A-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal go back to normal mode
tnoremap <silent><Esc> <C-\><C-n>
tnoremap <silent>:q! <C-\><C-n>:q!<CR>

" Run Python current buffer
autocmd FileType python map <buffer> <C-SPACE> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <C-SPACE> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" Commentary for kivy language
" I've try but no success right now
" augroup filetypedetect
" 	au! BufRead, BufNewFile *.kv setfiletype kivy
" augroup END

" autocmd FileType kivy setlocal commentstring=#\ %s

" Save foldings automatically
augroup remember_folds
  autocmd!
  au BufWinLeave ?* mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END
