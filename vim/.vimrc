" See: http://vimdoc.sourceforge.net/htmldoc/options.html
" See: https://learnvimscriptthehardway.stevelosh.com/
" See: `:help option-list`

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reset.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specify the character encoding used in the script.
scriptencoding utf-8

" Set all options to their default value.
set all&

" Reset color scheme.
colorscheme default


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Options.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on

filetype plugin indent on

" Read file when changed outside of Vim.
set autoread

" "dark" or "light", used for highlight colors.
set background=dark

" Keep backup file after overwriting a file.
set nobackup

" Columns to highlight.
set colorcolumn=80,120

" Highlight the screen line of the cursor.
set cursorline

" Encoding used internally.
set encoding=utf-8

" Use spaces when <Tab> is inserted.
set expandtab

" Set to display all folds open.
set nofoldenable

" Number of command-lines that are remembered.
set history=512

" Highlight matches with last search pattern.
set hlsearch

" Ignore case in search patterns.
set ignorecase

" Tells when last window has status lines.
set laststatus=2 " Always.

" Don't redraw while executing macros.
set lazyredraw

" Show <Tab> and <EOL>.
set list

" Characters for displaying in list mode.
set listchars=eol:¬,tab:>-,space:·,trail:·,extends:>,precedes:<

" Enable the use of mouse clicks.
set mouse=a

" Print the line number in front of each line.
set number

" Number of spaces to use for (auto)indent step.
set shiftwidth=2

" Tells when the tab pages line is displayed.
set showtabline=2 " Always.

" No ignore case when pattern has uppercase.
set smartcase

" Use 'shiftwidth' when inserting <Tab>.
set smarttab

" Number of spaces that <Tab> uses while editing.
set softtabstop=2

" New window from split is below the current one.
set splitbelow

" New window is put right of the current one.
set splitright

" Whether to use a swapfile for a buffer.
set noswapfile

" Long lines wrap and continue on the next line.
set nowrap

" Make a backup before overwriting a file.
set nowritebackup


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin("~/.vim/plugged")

" EditorConfig plugin for Vim.
" See: https://github.com/editorconfig/editorconfig-vim
Plug 'editorconfig/editorconfig-vim'

" Vim plugin for intensely nerdy commenting powers.
" See: https://github.com/preservim/nerdcommenter
Plug 'preservim/nerdcommenter'

" A tree explorer plugin for vim.
" See: https://github.com/preservim/nerdtree
Plug 'preservim/nerdtree'

" The undo history visualizer for VIM.
" See: https://github.com/mbbill/undotree
Plug 'mbbill/undotree'

" Lean & mean status/tabline for vim that's light as air.
" See: https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline'

" Vim motions on speed!
" See: https://github.com/easymotion/vim-easymotion
Plug 'easymotion/vim-easymotion'

" A Vim plugin which shows git diff markers in the sign column and
" stages/previews/undoes hunks and partial hunks.
" See: https://github.com/airblade/vim-gitgutter
Plug 'airblade/vim-gitgutter'

" Plugin to toggle, display and navigate marks.
" See: https://github.com/kshenoy/vim-signature
Plug 'kshenoy/vim-signature'

" surround.vim: quoting/parenthesizing made simple.
" See: https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand("~/.vim/colors/monokai/monokai.vim"))
  colorscheme monokai/monokai
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cursor line.
highlight CursorLineNR cterm=bold

" Whitespaces.
highlight SpecialKey ctermbg=NONE ctermfg=59 guifg=#75715E

" TODO(SuperPaintman): add custom colors for JavaScript and Markdown.
" if exists("g:colors_name") && g:colors_name == "monokai"
"
" endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE(SuperPaintman): `*` checks a function.
if !exists("*s:reload_config")
  function s:reload_config()
    source $MYVIMRC " Or `~/.vimrc`.
    echom "Config reloaded!"
  endfunction
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! ReloadConfig call s:reload_config()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check if an buffer was changed outside of Vim.
augroup checktime_on_cursor_hold
  autocmd!
  autocmd CursorHold * :checktime
augroup END

" NERDTreeRefreshRoot
augroup auto_refrest_nerd_tree
  autocmd!
  autocmd BufEnter,CmdlineLeave,CursorHold,CursorHoldI * :NERDTreeRefreshRoot
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree.
" See: https://github.com/preservim/nerdtree/blob/master/doc/NERDTree.txt
"" Manage the interpretation of mouse clicks.
let g:NERDTreeMouseMode = 3 " Single click.

"" Tells the NERDTree whether to display hidden files on startup.
let g:NERDTreeShowHidden = 1

"" Sets the window size when the NERDTree is opened.
let g:NERDTreeWinSize = 20

"" Disables display of the 'Bookmarks' label and 'Press ? for help' text.
let g:NERDTreeMinimalUI = 1

" NERD Commenter.
" See: https://github.com/preservim/nerdcommenter/blob/master/doc/NERD_commenter.txt
" Specifies if empty lines should be commented (useful with regions).
let g:NERDCommentEmptyLines = 1

"" Specifies whether to add extra spaces around delimiters when commenting,
"" and whether to remove them when uncommenting.
let g:NERDSpaceDelims = 1

"" Specifies the default alignment to use, one of 'none', 'left', 'start', or 'both'.
let g:NERDDefaultAlign = "left"

" EasyMotion.
" See: https://github.com/easymotion/vim-easymotion/blob/master/doc/easymotion.txt
" Matching target keys by smartcase. You can type target keys more lazily.
let g:EasyMotion_smartcase = 1

" Matching signs target keys by smartcase like. E.g. type '1' and it matches
" both '1' and '!' in Find motion.
let g:EasyMotion_use_smartsign_us = 1

" undotree.
" See: https://github.com/mbbill/undotree/blob/master/doc/undotree.txt
" Set the undotree window layout.
let g:undotree_WindowLayou = 3

" Set to 1 to get short timestamps when |undotree_RelativeTimestamp| is also
" enabled.
let g:undotree_ShortIndicators = 1

" vim-airline.
" See: https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt
let g:airline_powerline_fonts = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <Space> as a <Leader>. Double quotes are required.
let mapleader = "\<Space>"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" See: `help :map-modes`

" Normal, Visual, Select, Operator-pending modes.
"" EasyMotion.
" TODO(SuperPaintman): `vnoremap` doesn't work here.
map <Leader> <Plug>(easymotion-prefix)
map <Leader>L <Plug>(easymotion-bd-jk)
map / <Plug>(easymotion-sn)

" Normal mode.
"" Reload vim config.
" nnoremap <Leader>vr :ReloadConfig<CR>

" Split window vertically.
nnoremap <C-w>N :vnew<CR>

" Move lines.
nnoremap <C-k> :move -2<CR>
nnoremap <C-j> :move +1<CR>

" NERDTree.
nnoremap <C-n> :NERDTreeFocus<CR>

" NERDCommenter.
" TODO(SuperPaintman): `nnoremap` doesn't work here.
nmap <C-_> <Plug>NERDCommenterToggle

" undotree.
nnoremap <Leader>u :UndotreeShow<CR>:UndotreeFocus<CR>
nnoremap <Leader>U :UndotreeHide<CR>

" Visual mode.
" NERDCommenter.
" TODO(SuperPaintman): `vnoremap` doesn't work here.
vmap <C-_> <Plug>NERDCommenterToggle<CR>gv

" Insert mode.
"" Escape.
inoremap jk <Esc>

" Operator-pending mode.
"" EasyMotion.
" TODO(SuperPaintman): `vnoremap` doesn't work here.
omap / <Plug>(easymotion-tn)
