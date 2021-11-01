" See: http://vimdoc.sourceforge.net/htmldoc/options.html
" See: https://learnvimscriptthehardway.stevelosh.com/
" See: `:help option-list`

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reset.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specify the character encoding used in the script.
scriptencoding utf-8

" Save old values.
let s:old_columns=&columns
let s:old_lines=&lines

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

" How backspace works at start of line.
set backspace=indent,eol,start

" Keep backup file after overwriting a file.
set nobackup

" Columns to highlight.
set colorcolumn=80,120

" Set default number of columns of the screen.
let &columns=s:old_columns

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

" Set default number of lines of the window.
let &lines=s:old_lines

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

" Use ~/.vim as the runtime path.
set runtimepath^=~/.vim,~/.vim/after

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
if filereadable(expand("~/.vim/autoload/plug.vim"))
  call plug#begin("~/.vim/plugged")

  " Intellisense engine for Vim8 & Neovim, full language server protocol support
  " as VSCode .
  if (has("patch-8.1.1719") || (has("nvim") && has("nvim-0.4.3"))) && !exists("g:vscode")
    " See: https://github.com/neoclide/coc.nvim
    " See: https://github.com/neoclide/coc.nvim/wiki/Language-servers
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  endif

  " EditorConfig plugin for Vim.
  " See: https://github.com/editorconfig/editorconfig-vim
  Plug 'editorconfig/editorconfig-vim'

  " Vim plugin for intensely nerdy commenting powers.
  " See: https://github.com/preservim/nerdcommenter
  Plug 'preservim/nerdcommenter'

  " A tree explorer plugin for vim.
  if !exists("g:vscode")
    " See: https://github.com/preservim/nerdtree
    Plug 'preservim/nerdtree'
  endif

  " The undo history visualizer for VIM.
  if !exists("g:vscode")
    " See: https://github.com/mbbill/undotree
    Plug 'mbbill/undotree'
  endif

  " Lean & mean status/tabline for vim that's light as air.
  if !exists("g:vscode")
    " See: https://github.com/vim-airline/vim-airline
    Plug 'vim-airline/vim-airline'
  endif

  " Vim motions on speed!
  if !exists("g:vscode")
    " See: https://github.com/easymotion/vim-easymotion
    Plug 'easymotion/vim-easymotion'
  else
    " See: http://github.com/asvetliakov/vim-easymotion
    Plug 'asvetliakov/vim-easymotion', { 'as': 'vsc-easymotion' }
  endif

  " A Vim plugin which shows git diff markers in the sign column and
  " stages/previews/undoes hunks and partial hunks.
  if !exists("g:vscode")
    " See: https://github.com/airblade/vim-gitgutter
    Plug 'airblade/vim-gitgutter'
  endif

  " Vim plugin for C/C++/ObjC semantic highlighting using cquery, ccls, or
  " clangd.
  if !exists("g:vscode")
    " See: https://github.com/jackguo380/vim-lsp-cxx-highlight
    Plug 'jackguo380/vim-lsp-cxx-highlight'
  endif

  " True Sublime Text style multiple selections for Vim.
  " See: https://github.com/terryma/vim-multiple-cursors
  " Plug 'terryma/vim-multiple-cursors'

  " Plugin to toggle, display and navigate marks.
  if !exists("g:vscode")
    " See: https://github.com/kshenoy/vim-signature
    Plug 'kshenoy/vim-signature'
  endif

  " surround.vim: quoting/parenthesizing made simple.
  " See: https://github.com/tpope/vim-surround
  Plug 'tpope/vim-surround'

  call plug#end()
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand("~/.vim/colors/monokai/monokai.vim")) && !exists("g:vscode")
  colorscheme monokai/monokai
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cursor line.
highlight CursorLineNR cterm=bold

" Whitespaces.
highlight SpecialKey ctermbg=NONE ctermfg=239 guifg=#75715E

" TODO(SuperPaintman): add custom colors for JavaScript and Markdown.
" if exists("g:colors_name") && g:colors_name == "monokai"
"
" endif

" Override popup menu colors.
if exists("g:colors_name") && g:colors_name == "monokai"
  highlight Pmenu ctermbg=237 ctermfg=252 guibg=#3a3a3a guifg=#E8E8E3
  highlight PmenuSel ctermbg=237 ctermfg=252 guibg=#3a3a3a guifg=#E8E8E3
endif

" Custom colors for coc.nvim.
if exists("g:colors_name") && g:colors_name == "monokai"
  highlight CocHighlightText ctermbg=236 ctermfg=231 guibg=#383a3e guifg=#FFFFFF
endif

" Custom colors for C++ semantic highlighting.
highlight default link cOperator Operator

if exists("g:colors_name") && g:colors_name == "monokai"
  highlight cInclude ctermfg=197 guifg=#F92772
  highlight cDefine ctermfg=197 guifg=#F92772
  highlight cThis ctermfg=141 guifg=#AE81FF
  highlight LspCxxHlSymNamespace ctermfg=252 guifg=#E8E8E3
  highlight LspCxxHlSymClass ctermfg=81 guifg=#66D9EF
  " highlight LspCxxHlSymClass ctermfg=148 guifg=#A6E22D
endif


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

function! s:plug_has_plugin(name)
  if !exists("g:plugs")
    return 0
  endif

  return has_key(g:plugs, a:name)
endfunction

" check_back_space checks if the current character is a whitespace.
function s:check_back_space()
  let col = col(".") - 1
  return !col || getline(".")[col - 1] =~# "\s"
endfunction

" show_documentation shows documentation in preview window.
function s:show_documentation()
  if (index(["vim", "help"], &filetype) >= 0)
    execute "h ".expand("<cword>")
  else
    call CocAction("doHover")
  endif
endfunction

function s:fix_c_syntax()
  " Operators.
  "" - + % < > ~ ! & | ^ * = ? : .
  syntax match cOperator /[-+%<>~!&|^*=?:.]/

  "" /
  syntax match cOperator /\/\%(\ze[^/*]\)/

  " `this`.
  syntax keyword cThis this
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! ReloadConfig call <SID>reload_config()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check if an buffer was changed outside of Vim.
augroup checktime_on_cursor_hold
  autocmd!
  autocmd CursorHold * :checktime
augroup END

" NERDTreeRefreshRoot.
if s:plug_has_plugin("nerdtree")
  augroup auto_refrest_nerd_tree
    autocmd!
    autocmd BufEnter,CmdlineLeave,CursorHold,CursorHoldI * :NERDTreeRefreshRoot
  augroup END
endif

" coc.nvim autoformat.
if s:plug_has_plugin("coc.nvim")
  augroup autoformat_on_save
    autocmd!
    autocmd BufWritePre * call CocAction("format")
  augroup END
endif

" Highlight the symbol and its references when holding the cursor.
if s:plug_has_plugin("coc.nvim")
  augroup highlight_symbol_and_references
    autocmd!
    autocmd CursorHold * silent call CocActionAsync("highlight")
  augroup END
endif

augroup fix_c_syntax_on_syntax
  autocmd!
  autocmd Syntax cpp call s:fix_c_syntax()
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc.nvim.
" See: https://github.com/neoclide/coc.nvim/blob/master/doc/coc.txt
"" Global extension names to install when they aren't installed.
let g:coc_global_extensions = []
""" C/C++/Objective-C.
call add(g:coc_global_extensions, "coc-clangd")

" NERDTree.
" See: https://github.com/preservim/nerdtree/blob/master/doc/NERDTree.txt
"" Manage the interpretation of mouse clicks.
let g:NERDTreeMouseMode = 3 " Single click.

"" Tells the NERDTree whether to display hidden files on startup.
let g:NERDTreeShowHidden = 1

"" Sets the window size when the NERDTree is opened.
let g:NERDTreeWinSize = 30

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

let g:airline_theme = "dark"

" Enable/disable enhanced tabline.
let g:airline#extensions#tabline#enabled = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <Space> as a <Leader>. Double quotes are required.
let mapleader = "\<Space>"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO(SuperPaintman): `<Plug>` key cannot be used with `noremap`.
" See: `help :map-modes`

" Normal, Visual, Select, Operator-pending modes.
"" EasyMotion.
if s:plug_has_plugin("vim-easymotion") || s:plug_has_plugin("vsc-easymotion")
  map <Leader> <Plug>(easymotion-prefix)
  map <Leader>L <Plug>(easymotion-bd-jk)
  map / <Plug>(easymotion-sn)
endif

" Normal mode.
"" Reload vim config.
" nnoremap <Leader>vr :ReloadConfig<CR>

" Split window vertically.
nnoremap <C-w>N :vnew<CR>

" Move lines.
nnoremap <C-k> :move -2<CR>
nnoremap <C-j> :move +1<CR>

" coc.nvim.
"" Navigate diagnostics
if s:plug_has_plugin("coc.nvim")
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  "" GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  "" Show documentation.
  nnoremap <silent> gh :call <SID>show_documentation()<CR>

  "" Symbol renaming.
  nmap <Leader>rn <Plug>(coc-rename)
endif

" NERDTree.
if s:plug_has_plugin("nerdtree")
  nnoremap <C-n> :NERDTreeFocus<CR>
endif

" NERDCommenter.
if s:plug_has_plugin("nerdcommenter")
  nmap <C-_> <Plug>NERDCommenterToggle
endif

" undotree.
if s:plug_has_plugin("undotree")
  nnoremap <Leader>u :UndotreeShow<CR>:UndotreeFocus<CR>
  nnoremap <Leader>U :UndotreeHide<CR>
endif

" Visual mode.
" NERDCommenter.
if s:plug_has_plugin("nerdcommenter")
  vmap <C-_> <Plug>NERDCommenterToggle<CR>gv
endif

" Insert mode.
"" Escape.
if !exists("g:vscode")
  inoremap jk <Esc>
endif

" Close popup window on <Esc>.
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"

" coc.nvim.
if s:plug_has_plugin("coc.nvim")
  "" Use tab for trigger completion with characters ahead and navigate.
  inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  "" Use <cr> to confirm completion.
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Operator-pending mode.
"" EasyMotion.
if s:plug_has_plugin("vim-easymotion") || s:plug_has_plugin("vcs-easymotion")
  omap / <Plug>(easymotion-tn)
endif
