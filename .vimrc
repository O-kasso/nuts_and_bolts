" fzf fuzzy-finder in vim
set rtp+=/usr/local/opt/fzf
set runtimepath^=~/.vim/fzf.vim

" plugin manager
execute pathogen#infect()

" make shit look pretty
syntax enable
syntax on
set number
set relativenumber
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set textwidth=80
set smartindent
set mouse=a
set ttymouse=sgr " make clicking work properly
set scrolloff=999
set splitbelow
set splitright
set textwidth=180
filetype indent on
filetype plugin indent on
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guicursor+=n:hor20-Cursor/lCursor "underscore cursor in normal mode
set guifont=Roboto_Mono_for_Powerline:h12
" IF NOT USING Powerline fonts, good default font:
"set guifont=Menlo:h12


" vim-airline statusbar
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='solarized'
set t_Co=256
set laststatus=2
"   Use if shit looks weird
"let g:bufferline_echo = 0

" make indent guides visible
" autocmd VimEnter * :IndentGuidesEnable

colorscheme solarized
let g:solarized_termcolors=16
let g:solarized_visibility ="high"

"highlight current cursorline number
set cursorline
hi CursorLineNr term=bold ctermfg=6 gui=bold guifg=Green

" make sure indenting works properly with keywords like elsif/end
set runtimepath^=~/.vim/bundle/vim-endwise/plugin/endwise.vim

set runtimepath^=~/.vim/bundle/undotree/plugin/undotree.vim

" Use Mac OS X's clipboard for copy/pasting
set clipboard=unnamed

" backspace from anywhere
set backspace=2

" make lowercase searches case insensitive, but keep searches with capitals case sensitive
set smartcase

" save undo
set undofile
set undodir=$HOME/.vim/undo

" make gitgutter update faster
set updatetime=250

" Run checktime in buffers, but avoiding the Command Line (q:) window
au CursorHold * if getcmdwintype() == '' | checktime | endif

" navigate between splits more easily (ctrl+HJKL)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent> <Leader>= :exe "vertical resize +5"<CR>
nnoremap <silent> <Leader>- :exe "vertical resize -5"<CR>

" quit current split
nnoremap <C-Q> <C-W><C-Q>

" FZF shortcuts
" Open files in current window
nnoremap <silent> <Leader><Leader> :call fzf#run({'sink': 'e'})<CR>

" Open files in new horizontal split
nnoremap <silent> <Leader>s :call fzf#run({
\   'down': '40%',
\   'sink': 'split' })<CR>

" Open files in new vertical horizontal split
nnoremap <silent> <Leader>v :call fzf#run({
\   'right': winwidth('.') / 2,
\   'sink':  'vertical split' })<CR>

" automatically remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" source .vimrc
command! SO source ~/.vimrc

" shortcut to launch NERDTree
command! NT NERDTree

" shortcut for vim's native Explorer
command! EX Explore

" shortcut for Undotree
command! UN UndotreeToggle

" shortcut for Tagbar
command! TT TagbarToggle

"-----------------
" IF NOT USING VIM-AIRLINE, make statusline pretty
"   displays current filepath below viewport
"set statusline=%F%m%r%<\ %=%l,%v\ [%L]\ %p%%
"   Change the highlighting so it stands out
"hi statusline ctermbg=white ctermfg=black
"   Make sure it always shows
"set laststatus=2

"-----------------
let g:easytags_syntax_keyword = 'always'

augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

let g:indent_guides_guide_size=1
