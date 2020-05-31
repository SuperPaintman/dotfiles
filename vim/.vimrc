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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <Space> as a <Leader>. Double quotes are required.
let mapleader = "\<Space>"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Normal mode.
"" Reload vim config.
" nnoremap <Leader>vr :ReloadConfig<CR>

" Split window vertically.
nnoremap <C-w>N :vnew<CR>

" Move lines.
nnoremap <C-k> :move -2<CR>
nnoremap <C-j> :move +1<CR>

" Insert mode.
"" Escape.
inoremap jk <Esc>
