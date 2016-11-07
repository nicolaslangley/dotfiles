" ========
" Plugins
" ========

call plug#begin()

" UI
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'kshenoy/vim-signature'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/TaskList.vim'
Plug 'altercation/vim-colors-solarized'

" Tools
Plug 'jansenm/vim-cmake'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive' 
Plug 'Chiel92/vim-autoformat'
Plug 'derekwyatt/vim-fswitch'
Plug 'tyok/ack.vim' | Plug 'tyok/nerdtree-ack'
Plug 'ludovicchabant/vim-gutentags'
Plug 'jiangmiao/auto-pairs'
Plug 'rizzatti/dash.vim'
Plug 'critiqjo/lldb.nvim'
Plug 'neomake/neomake'
Plug 'vim-scripts/DoxygenToolkit.vim'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

" Syntax plugins
Plug 'beyondmarc/hlsl.vim' 
Plug 'tikhomirov/vim-glsl' 
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'JuliaLang/julia-vim'
Plug 'keith/swift.vim'
Plug 'vim-scripts/SyntaxRange'

call plug#end()

" ========
" Options
" ========

" UI
colorscheme solarized
highlight clear SignColumn
set guifont=Meslo\ LG\ S\ DZ\ REgular\ for\ Powerline:h12 " Font needs to be installed
set background=dark
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
let g:ctrlp_working_path_mode = 'rwa'
let g:python_host_prog = '/System/Library/Frameworks/Python.framework/Versions/2.7/bin/python' " Set python to be system python
let g:DoxygenToolkit_commentType = "C++"
let g:DoxygenToolkit_compactOneLineDoc = "yes"
let g:DoxygenToolkit_briefTag_pre = "\\brief "
let g:DoxygenToolkit_paramTag_pre = "\\param "
let g:DoxygenToolkit_returnTag = "\\return "
let g:gutentags_project_root = ['runtimecore']
let mapleader = ","

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
map <silent> <C-f> :NERDTreeFocus<cr>
map <silent> <C-n> :NERDTreeToggle<cr>
map <leader>b :TagbarToggle<cr>
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Opens search results in a window w/ links and highlight the matches - from http://chase-seibert.github.io/blog/2013/09/21/vim-grep-under-cursor.html
command! -nargs=+ Grep execute 'silent grep! -I -r -n --exclude *.{.tag} . -e <args>' | copen | execute 'silent /<args>'
" shift-contol-* Greps for the word under the cursor
nmap <leader>g :Grep <c-r>=expand("<cword>")<cr><cr> 

" ========
" Autocommands
" ========
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif " Close preview window on movement or entering insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" Note that a symlink has to be created with the syntax file from vim-glsl:
" 'mkdir syntax & ln -s plugged/vim-glsl/syntax/glsl.vim syntax/glsl.vim'
autocmd BufReadPost * call SyntaxRange#Include('// begin_glsl', '// end_glsl', 'hlsl', 'NonText') " Call SyntaxRange function to set GLSL highlighting within a string

