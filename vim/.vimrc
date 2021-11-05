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

if $TERM =~ "-256color" || $COLORTERM == "truecolor"
  " Enable 24-bit RGB color.
  set termguicolors
endif

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
  if exists("g:plug_update_all") || (has("patch-8.1.1719") || (has("nvim") && has("nvim-0.4.3"))) && !exists("g:vscode")
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
  if exists("g:plug_update_all") || !exists("g:vscode")
    " See: https://github.com/preservim/nerdtree
    Plug 'preservim/nerdtree'
  endif

  " The undo history visualizer for VIM.
  if exists("g:plug_update_all") || !exists("g:vscode")
    " See: https://github.com/mbbill/undotree
    Plug 'mbbill/undotree'
  endif

  " Lean & mean status/tabline for vim that's light as air.
  if exists("g:plug_update_all") || !exists("g:vscode")
    " See: https://github.com/vim-airline/vim-airline
    Plug 'vim-airline/vim-airline'
  endif

  " Vim motions on speed!
  if exists("g:plug_update_all") || !exists("g:vscode")
    " See: https://github.com/easymotion/vim-easymotion
    Plug 'easymotion/vim-easymotion'
  endif
  if exists("g:plug_update_all") || exists("g:vscode")
    " See: http://github.com/asvetliakov/vim-easymotion
    Plug 'asvetliakov/vim-easymotion', { 'as': 'vsc-easymotion' }
  endif

  " A Vim plugin which shows git diff markers in the sign column and
  " stages/previews/undoes hunks and partial hunks.
  if exists("g:plug_update_all") || !exists("g:vscode")
    " See: https://github.com/airblade/vim-gitgutter
    Plug 'airblade/vim-gitgutter'
  endif

  " Vim plugin for C/C++/ObjC semantic highlighting using cquery, ccls, or
  " clangd.
  if exists("g:plug_update_all") || !exists("g:vscode")
    " See: https://github.com/jackguo380/vim-lsp-cxx-highlight
    Plug 'jackguo380/vim-lsp-cxx-highlight'
  endif

  " True Sublime Text style multiple selections for Vim.
  " See: https://github.com/terryma/vim-multiple-cursors
  " Plug 'terryma/vim-multiple-cursors'

  " Multiple cursors plugin.
  if exists("g:plug_update_all") || !exists("g:vscode")
    " See: https://github.com/mg979/vim-visual-multi
    Plug 'mg979/vim-visual-multi'
  endif

  " Plugin to toggle, display and navigate marks.
  if exists("g:plug_update_all") || !exists("g:vscode")
    " See: https://github.com/kshenoy/vim-signature
    Plug 'kshenoy/vim-signature'
  endif

  " surround.vim: quoting/parenthesizing made simple.
  " See: https://github.com/tpope/vim-surround
  if exists("g:plug_update_all") || !exists("g:vscode")
    Plug 'tpope/vim-surround'
  endif

  " FZF integration.
  " if !exists("g:vscode")
  "   " See: https://github.com/junegunn/fzf
  "   Plug 'junegunn/fzf'
  "   Plug 'junegunn/fzf.vim'
  " endif

  call plug#end()

  if exists("g:plug_update_all")
    finish
  endif
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Schemes.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists("g:vscode")
  if filereadable(expand("~/.vim/autoload/onedark.vim")) && filereadable(expand("~/.vim/colors/onedark/onedark.vim"))
    colorscheme onedark/onedark
  endif

  " if filereadable(expand("~/.vim/colors/monokai/monokai.vim"))
  "   colorscheme monokai/monokai
  " endif
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

  if !has_key(g:plugs, a:name)
    return 0
  endif

  return isdirectory(g:plugs[a:name].dir)
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
    if s:plug_has_plugin("coc.nvim")
      if CocHasProvider("hover")
        call CocAction("doHover")
      endif
    endif
  endif
endfunction

function s:create_create_temp_file(cb)
  " Save current position.
  let view = winsaveview()
  let search = @/
  " let original_filetype = &filetype

  let tmp = tempname()

  try
    " Write current buffer into a temp file.
    let content = getline(1, "$")
    call writefile([], tmp) " Similar to the unix touch.
    call setfperm(tmp, "rw-------")
    call writefile(content, tmp)

    " Call the callback.
    let result = a:cb(tmp)

    " Set new content into the buffer.
    silent! execute 1 . "," . line('$') . "delete _"
    call setline(1, result)

    " Hack for VSCode sync.
    " if exists("g:vscode")
    "   sleep 100ms
    " endif
  finally
    " Delete the temp file.
    if filewritable(tmp)
      call delete(tmp)
    endif

    " Reset original position.
    if !exists("g:vscode")
      " if &filetype != original_filetype
      "   let &filetype = original_filetype
      " endif
      let @/ = search
      call winrestview(view)
    else
      " call timer_start(100, {-> let @/ = search})
      " call timer_start(100, {-> winrestview(view)})
    endif
  endtry
endfunction

function s:format_prettier(filename, parser)
  " Call formatter.
  let cmd = "prettier --parser=" . shellescape(a:parser) . " --write " . shellescape(a:filename)
  let output = system(cmd)
  if v:shell_error != 0
    throw output
  endif

  " Read new file content.
  return readfile(a:filename)
endfunction

function s:format_code()
  try
    if &filetype == "markdown"
      if executable("prettier")
        call s:create_create_temp_file({filename -> s:format_prettier(filename, "markdown")})
        return
      endif
    endif

    if &filetype == "json"
      if executable("prettier")
        call s:create_create_temp_file({filename -> s:format_prettier(filename, "json")})
        return
      endif
    endif

    if s:plug_has_plugin("coc.nvim")
      if CocHasProvider("format")
        call CocAction("format")
        return
      endif
    endif
  finally
    if exists("*gitgutter#all")
      call gitgutter#all(1)
    endif
  endtry
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

function s:setup_terminal()
  " Do not highlight columns.
  setlocal colorcolumn=
  " Do not highlight the cursor line.
  setlocal nocursorline
  " Do not show special characters.
  setlocal nolist
  " Do not print the line number.
  setlocal nonumber

  if exists("g:term_vt")
    " Do not show tabline.
    setlocal showtabline=0

    " TODO(SuperPaintman): set up the airline. I tried but on the refresh it drops the sections.
  endif
endfunction

if s:plug_has_plugin("vim-visual-multi")
  function s:scroll_down_or_vm_find_under()
    if g:Vm.extend_mode
      call vm#commands#ctrln(v:count1)
    else
      " let height = winheight(0)
      " let pos = winsaveview()
      " let pos.lnum = min([pos.lnum + (height / 2), line('$')])
      " let pos.topline = min([pos.topline + (height / 2), line('$') - height + 1])
      " call winrestview(pos)

      call feedkeys("<Local>(ScrollDown)")
    endif
  endfunction
endif

" VSCode.
if exists("g:vscode")
  function s:vscode_notify_visual(cmd, leaveSelection, ...)
    let mode = mode()
    if mode ==# 'V'
      let startLine = line('v')
      let endLine = line('.')
      call VSCodeNotifyRange(a:cmd, startLine, endLine, a:leaveSelection, a:000)
    elseif mode ==# 'v' || mode ==# "\<C-v>"
      let startPos = getpos('v')
      let endPos = getpos('.')
      call VSCodeNotifyRangePos(a:cmd, startPos[1], endPos[1], startPos[2], endPos[2] + 1, a:leaveSelection, a:000)
    else
      call VSCodeNotify(a:cmd, a:000)
    endif
  endfunction
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! ReloadConfig call <SID>reload_config()
command! FormatCode call <SID>format_code()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VSCode Neowim hacks.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" if exists("g:vscode")
"   " Run BufWritePre before the Write.
"   "
"   " Original:
"   " command! -complete=file -bang -nargs=? Write if <q-bang> ==# '!' | call VSCodeNotify('workbench.action.files.saveAs') | else | call VSCodeNotify('workbench.action.files.save') | endif
"   "
"   " See: https://github.com/asvetliakov/vscode-neovim/blob/master/vim/vscode-file-commands.vim
"   command! -complete=file -bang -nargs=? Write doautocmd BufWritePre
"     \ | if <q-bang> ==# '!' | call VSCodeNotify('workbench.action.files.saveAs') | else | call VSCodeNotify('workbench.action.files.save') | endif
" endif


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

" Auto format on save.
augroup autoformat_on_save
  autocmd!
  autocmd BufWritePre * call s:format_code()
augroup END

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

" Set up the Terminal.
augroup setup_terminal
  autocmd!
  if exists("##TermOpen")
    autocmd TermOpen * silent call s:setup_terminal()
    autocmd TermOpen * startinsert
  elseif exists('##TerminalOpen')
    autocmd TerminalOpen * silent call s:setup_terminal()
  end

  if exists("##TermClose")
    " TODO(SuperPaintman): add exit code. Neovim 5.1 does not support it.
    " autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif
    autocmd TermClose * if exists("g:term_vt") | :q! | endif
  end
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc.nvim.
if s:plug_has_plugin("coc.nvim")
  " See: https://github.com/neoclide/coc.nvim/blob/master/doc/coc.txt
  " See: https://github.com/neoclide/coc.nvim/wiki/Language-servers
  if isdirectory(expand("~/.vim"))
    let g:coc_config_home = expand("~/.vim")
  endif

  "" Global extension names to install when they aren't installed.
  let g:coc_global_extensions = []
  """ JSON.
  call add(g:coc_global_extensions, "coc-json")
  """ Markdown.
  call add(g:coc_global_extensions, "coc-markdownlint")
  """ C/C++/Objective-C.
  call add(g:coc_global_extensions, "coc-clangd")
  """ TypeScript/JavaScript.
  call add(g:coc_global_extensions, "coc-tsserver")
  """ Go
  " call add(g:coc_global_extensions, "coc-go")
endif

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

if filereadable(expand("~/.vim/autoload/airline/themes/onedark.vim"))
  let g:airline_theme = "onedark"
else
  let g:airline_theme = "dark"
endif

" Enable/disable enhanced tabline.
let g:airline#extensions#tabline#enabled = 1

" vim-visual-multi
" See: https://github.com/mg979/vim-visual-multi/blob/master/doc/vm-settings.txt
let g:VM_maps = {
  \ "Find Under": ""
  \ }
let g:VM_default_mappings = 0
let g:VM_case_setting = "sensitive"
let g:VM_notify_previously_selected = 2

" Neovide
" See: https://github.com/neovide/neovide/wiki/Configuration
if exists("neovide")
  set guifont=JetBrains\ Mono:h10

  let g:neovide_cursor_animation_length = 0
endif


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
" Clipboard.
if has("clipboard")
  map <Leader>y "+y
  map <Leader>p "+p
endif

"" EasyMotion.
if s:plug_has_plugin("vim-easymotion") || s:plug_has_plugin("vsc-easymotion")
  map <Leader> <Plug>(easymotion-prefix)
  map <Leader>L <Plug>(easymotion-bd-jk)
  map / <Plug>(easymotion-sn)
endif

" Normal mode.
"" Reload vim config.
" nnoremap <Leader>vr :ReloadConfig<CR>

" No highlight search.
nmap <silent> <Esc> :nohlsearch<CR>

" Split window vertically.
if !exists("g:vscode")
  nnoremap <C-w>N :new<CR>
  nnoremap <C-w>V :vnew<CR>
else
  nnoremap <C-w>N :New<CR>
  nnoremap <C-w>V :Vnew<CR>
endif

"" Tabs.
"" Tab new.
nmap <silent> <Leader>tn :tabnew<CR>

"" Tab close.
nmap <silent> <Leader>tq :tabclose<CR>

"" Tab next/previous.
nmap <silent> <Leader>th :tabprevious<CR>
nmap <silent> <Leader>tl :tabnext<CR>

"" Tab move next/previous.
nmap <silent> <Leader>tH :tabmove -1<CR>
nmap <silent> <Leader>tL :tabmove +1<CR>

"" Tab go.
for i in [1, 2, 3, 4, 5, 6, 7, 8, 9]
  execute "nmap <silent> <Leader>t" . i . " :tabnext " . i . "<CR>"
endfor

"" Tab go first/last.
nmap <silent> <Leader>t0 :tabfirst<CR>
nmap <silent> <Leader>t$ :tablast<CR>

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

" VSCode Debug.
if exists("g:vscode")
  " See: https://github.com/microsoft/vscode/blob/main/src/vs/workbench/contrib/debug/browser/debugCommands.ts

  " Debug breakpoint
  nmap <Leader>db <Cmd>call VSCodeNotify('editor.debug.action.toggleBreakpoint')<CR>
  nmap <Leader>dB <Cmd>call VSCodeNotify('editor.debug.action.toggleInlineBreakpoint')<CR>

  " Debug continue
  nmap <Leader>dc <Cmd>call VSCodeNotify('workbench.action.debug.continue')<CR>
  nmap <Leader>dC <Cmd>call VSCodeNotify('workbench.action.debug.reverseContinue')<CR>

  " Debug next/prev.
  nmap <Leader>dn <Cmd>call VSCodeNotify('editor.debug.action.goToNextBreakpoint')<CR>
  nmap <Leader>dN <Cmd>call VSCodeNotify('editor.debug.action.goToPreviousBreakpoint')<CR>

  " Debug pause
  nmap <Leader>dp <Cmd>call VSCodeNotify('workbench.action.debug.pause')<CR>

  " Debug run (start)
  nmap <Leader>dr <Cmd>call VSCodeNotify('workbench.action.debug.start')<CR>

  " Debug restart
  nmap <Leader>dR <Cmd>call VSCodeNotify('workbench.action.debug.restart')<CR>

  " Debug step
  nmap <Leader>ds <Cmd>call VSCodeNotify('workbench.action.debug.stepOver')<CR>
  nmap <Leader>dS <Cmd>call VSCodeNotify('workbench.action.debug.stepBack')<CR>

  " Debug quit (stop)
  nmap <Leader>dq <Cmd>call VSCodeNotify('workbench.action.debug.stop')<CR>

  " Debug quit view
  nmap <Leader>dQ <Cmd>call VSCodeNotify('workbench.debug.action.focusRepl')<CR><Cmd>call VSCodeNotify('workbench.action.closePanel')<CR>

  " Debug remove all breakpoints
  nmap <Leader>dX <Cmd>call VSCodeNotify('workbench.debug.viewlet.action.removeAllBreakpoints')<CR>

  " Debug focus
  " nmap <Leader>dz <Cmd>call VSCodeNotify('debug.jumpToCursor')<CR>
endif

" VSCode Diff (Git).
if exists("g:vscode")
  " See: https://github.com/microsoft/vscode/blob/main/extensions/git/src/commands.ts
  " See: https://github.com/microsoft/vscode/blob/main/src/vs/workbench/contrib/scm/browser/dirtydiffDecorator.ts
  " See: https://github.com/hlissner/doom-emacs/blob/4903db036d7342be7efbe0c6bd6978ad4873c1a3/modules/config/default/%2Bemacs-bindings.el#L350

  " Git next/prev
  nmap <Leader>gn <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>
  nmap <Leader>gN <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>

  " Git revert
  " nmap <Leader>gr <Cmd>call VSCodeNotify('git.revertChange')<CR>
  nmap <Leader>gr <Cmd>call VSCodeNotify('git.revertSelectedRanges')<CR>
  vmap <Leader>gr <Cmd>call <SID>vscode_notify_visual('git.revertSelectedRanges', 1)<CR>

  " Git stage.
  " TODO(SuperPaintman): replace it with hunk staging. At the moment VSCode
  " can't do it.
  " nmap <Leader>gs <Cmd>call VSCodeNotify('git.stageChange')<CR>
  nmap <Leader>gs <Cmd>call VSCodeNotify('git.stageSelectedRanges')<CR>
  vmap <Leader>gs <Cmd>call <SID>vscode_notify_visual('git.stageSelectedRanges', 1)<CR>

  " Git unstage.
  " nmap <Leader>gu <Cmd>call VSCodeNotify('git.unstageChange')<CR>
  nmap <Leader>gu <Cmd>call VSCodeNotify('git.unstageSelectedRanges')<CR>
  vmap <Leader>gu <Cmd>call <SID>vscode_notify_visual('git.unstageSelectedRanges', 1)<CR>
endif

" undotree.
if s:plug_has_plugin("undotree")
  nnoremap <Leader>u :UndotreeShow<CR>:UndotreeFocus<CR>
  nnoremap <Leader>U :UndotreeHide<CR>
endif

" Visual mode.
" Paste / change / delete without replacing.
vmap P "_dP
vmap C "_c
vmap D "_d

" NERDCommenter.
if s:plug_has_plugin("nerdcommenter")
  vmap <C-_> <Plug>NERDCommenterToggle<CR>gv
endif

" vim-visual-multi
if s:plug_has_plugin("vim-visual-multi")
  nnoremap <Local>(ScrollDown) <C-d>
  nmap <silent> <C-d> :call <SID>scroll_down_or_vm_find_under()<CR>
  vmap <C-d> <Plug>(VM-Find-Subword-Under)
endif

" VSCode multiline
if exists("g:vscode")
  " TODO(SuperPaintman): it does not work because VSCode Neovim uses the native
  " command.
  " See: https://github.com/asvetliakov/vscode-neovim/blob/master/src/commands_controller.ts
  " vmap <C-d> <Cmd>call VSCodeNotify('editor.action.addSelectionToNextFindMatch')<CR>
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

" Terminal mode.
if exists(":tnoremap")
  tnoremap <Esc><Space> <C-\><C-n>
endif
