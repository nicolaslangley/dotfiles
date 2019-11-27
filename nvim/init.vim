" ========
" Plugins
" ========

call plug#begin()

" UI
Plug 'scrooloose/nerdtree'
" Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'kshenoy/vim-signature'
" Plug 'airblade/vim-gitgutter'
" Plug 'tomasiser/vim-code-dark'
Plug 'ayu-theme/ayu-vim'
Plug 'vim-airline/vim-airline-themes'
" Plug 'mhartington/oceanic-next'

" Tools
" Plug 'mileszs/ack.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'nixprime/cpsm'
Plug 'derekwyatt/vim-fswitch'
" Plug 'tyok/nerdtree-ack'
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'jiangmiao/auto-pairs'
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'neomake/neomake'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
" Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

" Syntax plugins
Plug 'beyondmarc/hlsl.vim' 
Plug 'tikhomirov/vim-glsl' 
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'vim-scripts/SyntaxRange'
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
" let g:oceanic_next_terminal_bold = 1
" let g:oceanic_next_terminal_italic = 1
" colorscheme OceanicNext
let g:airline_theme = 'simple'
highlight clear SignColumn
" set guifont=Meslo\ LG\ S\ DZ\ REgular\ for\ Powerline:h12 " Font needs to be installed
" set background=dark
set number
set relativenumber

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

" ========
" Assignments
" ========
let macvim_skip_colorscheme=1 " Don't override coloscheme in MacVim
let g:NERDTreeShowHidden=1 " Show hidden files in NERDTree by default
let g:gitgutter_highlight_lines=0 " Highlight changed lines
let g:tlTokenList=["FIXME", "TODO", "???", "XXX"]
let g:deoplete#enable_at_startup=1
let g:neomake_cpp_enable_makers=['clang']
let g:neomake_cpp_clang_args = ["-std=c++11", "-Wextra", "-Wall", "-g"]
let g:ctrlp_map = ''
let g:ctrlp_working_path_mode = 'rwa'
let g:ctrlp_user_command = 'fd --type f --color=never "" %s'
let g:ctrlp_use_caching = 0
let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }
let g:python_host_prog = '/System/Library/Frameworks/Python.framework/Versions/2.7/bin/python' " Set python to be system python
let g:DoxygenToolkit_commentType = "C++"
let g:DoxygenToolkit_compactOneLineDoc = "yes"
let g:DoxygenToolkit_briefTag_pre = "\\brief "
let g:DoxygenToolkit_paramTag_pre = "\\param "
let g:DoxygenToolkit_returnTag = "\\return "
let g:gutentags_project_root = ['runtimecore']
let mapleader = ","
let g:clang_format#command = '~/Development/Quartz/runtimecore/runtimecore_scripts/tools/clang-format/clang-formatOSX'
let g:clang_format#enable_fallback_style = 0
let g:clang_format#detect_style_file = 1

if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case' " Use The Silver Searcher instead of ack for ack.vim
  cnoreabbrev ag Ack!
  cnoreabbrev aG Ack!
  cnoreabbrev Ag Ack!
  cnoreabbrev AG Ack!
  nnoremap <Leader>a :Ack!<Space>
  " Use ack.vim in support mode
  xnoremap <Leader>av y:Ack! <C-r>=fnameescape(@")<CR><CR> 
endif

if executable('clangd')
  au User lsp_setup call lsp#register_server({
      \ 'name': 'clangd',
      \ 'cmd': {server_info->['clangd']},
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
      \ })
endif

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
" autocmd CursorMovedI * if pumvisible() == 0|pclose|endif " Close preview window on movement or entering insert mode
" autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" Note that a symlink has to be created with the syntax file from vim-glsl:
" 'mkdir syntax & ln -s plugged/vim-glsl/syntax/glsl.vim syntax/glsl.vim'
autocmd BufReadPost * call SyntaxRange#Include('// begin_glsl', '// end_glsl', 'glsl', 'NonText') " Call SyntaxRange function to set GLSL highlighting within a string
au BufRead,BufNewFile *.mm,*.m set filetype=objc
au BufRead,BufNewFile *.metal set filetype=cpp
autocmd FileType c,cpp,objc ClangFormatAutoEnable
if has('nvim')
  aug fzf_setup
    au!
    au TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>
  aug END
end
