" ========
" Plugins
" ========

call plug#begin()

" UI
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'ayu-theme/ayu-vim'
Plug 'vim-airline/vim-airline-themes'

" Tools
Plug 'jremmen/vim-ripgrep'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'nixprime/cpsm'
Plug 'derekwyatt/vim-fswitch'

" Syntax plugins
Plug 'beyondmarc/hlsl.vim' 
Plug 'tikhomirov/vim-glsl' 
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rhysd/vim-clang-format'
Plug 'SolaWing/vim-objc-syntax'

" My plugins
" Plug 'nicolaslangley/vim-lldb-breakpoints'

call plug#end()

" ========
" Options
" ========

" UI
" set termguicolors     " enable true colors support
let ayucolor="mirage" " for mirage version of theme
colorscheme ayu
let g:airline_theme = 'simple'
highlight clear SignColumn
set number

" Search
set hlsearch
set incsearch

" Editing
syntax on
set expandtab
set shiftwidth=2
set softtabstop=2

" Folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set cursorline

set hidden

" Use Ripgrep with crtlp if available
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" ========
" Assignments
" ========
let g:NERDTreeShowHidden=1 " Show hidden files in NERDTree by default
let g:ctrlp_map = ''
let g:ctrlp_working_path_mode = 'rwa'
let g:ctrlp_user_command = 'fd --type f --color=never "" %s'
let g:ctrlp_use_caching = 0
let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }
let g:python_host_prog = '/System/Library/Frameworks/Python.framework/Versions/2.7/bin/python' " Set python to be system python
let mapleader = ","
let g:clang_format#command = '~/Development/Quartz/tools/llvm/9.0.0/bin/clang-format'
let g:clang_format#enable_fallback_style = 0
let g:clang_format#detect_style_file = 1

augroup cppfiles " Setting for FSwitch plugin to handle switching between .cpp and .h headers
  au!
  au BufEnter *.h let b:fswitchdst = 'cpp'
  au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/'
  au BufEnter *.h let b:fsnonewfiles = 'on'
augroup END

" ========
" Mappings
" ========
noremap <leader>. :CtrlPTag<cr>
nnoremap <silent> <Leader>v :NERDTreeFind<CR>
map <silent> <C-f> :NERDTreeFocus<cr>
map <silent> <C-n> :NERDTreeToggle<cr>
map <leader>b :TagbarToggle<cr>
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
nnoremap <silent> <C-l> :let g:cpsm_match_empty_query = 0<CR>:CtrlPMRU<CR>
nnoremap <silent> <C-p> :let g:cpsm_match_empty_query = 1<CR>:CtrlP<CR>

" ========
" Autocommands
" ========
au BufRead,BufNewFile *.mm,*.m set filetype=objc
au BufRead,BufNewFile *.metal set filetype=cpp
autocmd FileType c,cpp,objc ClangFormatAutoEnable
