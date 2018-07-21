execute pathogen#infect()

" Langmenu
if has("gui_running")
  set langmenu=en_US
  let $LANG = &langmenu
endif

syntax on
filetype plugin indent on

" Encoding
scriptencoding utf-8
set encoding=utf-8

" guifont
if has("gui_running")
  if has("win32") || has("win64")
    set guifont=Consolas:h14
  endif
endif

" Theme
try
  " colorscheme vim-tomorrow-theme/Tomorrow-Night
  colorscheme monokai/monokai
catch
endtry

" Custom colors
"" Common
""" Line cursor line
hi CursorLine   cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
hi CursorLineNR cterm=bold

"" JavaScript
if exists('g:colors_name') && g:colors_name == 'monokai'
  """ normal
  hi Normal ctermbg=234 guibg=#272822

  """ template string braces
  hi jsTemplateBraces ctermbg=NONE ctermfg=179 guifg=#e69f66
endif

"" Markdown
if exists('g:colors_name') && g:colors_name == 'monokai'
  """ Bold
  hi markdownBold     term=bold   cterm=bold    gui=bold    ctermfg=197 guifg=#f92772

  "" Italic
  hi markdownItalic   term=italic cterm=italic  gui=italic  ctermfg=197 guifg=#f92772

  "" Bold Italic
  hi markdownBoldItalic term=bold,italic cterm=bold,italic gui=bold,italic ctermfg=197 guifg=#f92772

  """ Headings
  hi markdownHeadingDelimiter ctermfg=208 guifg=#FD9720
  hi markdownH1 ctermfg=208 guifg=#FD9720
  hi markdownH2 ctermfg=208 guifg=#FD9720
  hi markdownH3 ctermfg=208 guifg=#FD9720
  hi markdownH4 ctermfg=208 guifg=#FD9720
  hi markdownH5 ctermfg=208 guifg=#FD9720
  hi markdownH6 ctermfg=208 guifg=#FD9720

  """ Rule
  hi markdownRule term=bold cterm=bold gui=bold ctermfg=243 guifg=#8F908A ctermbg=237 guibg=#575b61
endif

"" Grey whitespaces
hi SpecialKey ctermbg=NONE ctermfg=59 guifg=#75715E

" Highlight all search matches
set hlsearch

" Drawing
set lazyredraw

" Statusline
set laststatus=2

" Line numbers
set cursorline
set number

" Show hidden characters
try
  set listchars=eol:¬,tab:>-,space:·,trail:·,extends:>,precedes:<
catch
  set listchars=eol:¬,tab:>-,trail:·,extends:>,precedes:<
endtry
set list

" Cases
set ignorecase
set smartcase

" Indentation settings
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab

" Ruler
set colorcolumn=80

" Linebreak on 80 characters
set lbr
set tw=80

set nowrap

" Tabs
set showtabline=2

" Splites
set splitright
set splitbelow

" Files, backups, etc
set nobackup
set nowb
set noswapfile

" Mappings
"" Disable Arrows
noremap <Left>  <Nop>
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Right> <Nop>

"" Escape
imap jk <Esc>

"" Tabs
nmap ,t :tabnew<CR>
nmap ,T :tabclose<CR>

"" Splites
nmap <C-w>N :vnew<CR>

"" Swap lines
nnoremap <C-k> :m -2<CR>
nnoremap <C-j> :m +1<CR>

"" NERDTree
try
  map <C-n> :NERDTreeToggle<CR>
catch
endtry

"" NERDCommenter
try
  map <C-_> <plug>NERDCommenterComment
  map <C-?> <plug>NERDCommenterToggle
catch
endtry

"" EasyMotion
try
  map <Leader> <Plug>(easymotion-prefix)

  map  / <Plug>(easymotion-sn)
  omap / <Plug>(easymotion-tn)

  map <Leader>L <Plug>(easymotion-bd-jk)
  "nmap <Leader>L <Plug>(easymotion-overwin-line)
catch
endtry

"" undotree
try
  nmap ,u :UndotreeToggle<CR>
catch
endtry

"" Tagbar
try
  nmap ,x :TagbarToggle<CR>
catch
endtry

" Filetypes
autocmd BufRead,BufNewFile *.babelrc setfiletype json

" Syntax
"" JavaScripe
function! AutoCMDSyntaxJS()
  " ...
  syntax match   jsOperator       /\.\.\./

  syntax keyword jsGlobalObjects  Buffer __dirname __filename console module exports global process

  " async / await
  syntax clear jsAsyncKeyword
  syntax keyword jsAsyncKeyword   async
  syntax keyword jsAwaitKeyword   await
  syntax cluster jsAll            add=jsAwaitKeyword
endfunction
autocmd Syntax javascript call AutoCMDSyntaxJS()

""" TODO: сделать подсветку Noise '.', ':' красным

" Highlight linking
"" JavaScript
hi def link jsFuncCall Function
hi def link jsObjectKey String
hi def link jsSwitchColon Delimiter
hi def link jsGlobalObjects Keyword
hi def link jsTemplateVar NONE
"hi def link jsNoiseDot Operator
hi! def link jsAwaitKeyword Statement
hi! def link jsThis Special
hi! def link jsSuper Statement
hi! def link jsClassDefinition jsFuncName
hi! def link jsUndefined Special
hi! def link jsNull Special

"" Markdown
hi! def link markdownIdDeclaration Float
hi! def link markdownUrl htmlLink
hi! def link markdownLinkText Type
hi! def link markdownId Float

" Plugins Config
"" JavaScript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1

"" Python
let python_highlight_all = 1

"" Markdown
let g:markdown_fenced_languages = [
  \'javascript',
  \'js=javascript',
  \'sh',
  \'bash=sh',
  \'yaml'
  \]

"" NERDTree
let g:NERDTreeShowHidden = 1

"" Tagbar
""" see: https://github.com/ramitos/jsctags
let g:tagbar_type_javascript = {
  \'ctagsbin': 'jsctags'
  \}

let g:tagbar_type_crystal = {
  \'ctagstype': 'ruby',
  \'kinds': [
    \'m:modules',
    \'c:classes',
    \'d:describes',
    \'C:contexts',
    \'f:methods',
    \'F:singleton methods'
    \]
  \}

""" see: https://github.com/jszakmeister/markdown2ctags
let g:tagbar_type_markdown = {
  \'ctagstype': 'markdown',
  \'ctagsbin': '/usr/local/bin/markdown2ctags',
  \'ctagsargs': '-f - --sort=yes',
  \'kinds': [
    \'s:sections',
    \'i:images'
    \],
  \'sro': '|',
  \'kind2scope' : {
    \'s' : 'section',
    \},
  \'sort': 0,
  \}

" Presets
"" NERDTree
" try
"   autocmd vimenter * NERDTree
" catch
" endtry
