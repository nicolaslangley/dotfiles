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
Plug 'dkprice/vim-easygrep'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive' 
Plug 'Chiel92/vim-autoformat'
Plug 'tyok/ack.vim' | Plug 'tyok/nerdtree-ack'
Plug 'vim-scripts/DfrankUtil'
Plug 'vim-scripts/vimprj' 
Plug 'vim-scripts/indexer.tar.gz' " CTags automatic updating
Plug 'rizzatti/dash.vim'
Plug 'critiqjo/lldb.nvim'
Plug 'neomake/neomake'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

" Syntax plugins
Plug 'beyondmarc/hlsl.vim' 
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'JuliaLang/julia-vim'
Plug 'keith/swift.vim'

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

" ========
" Assignments
" ========
let macvim_skip_colorscheme=1 " Don't override coloscheme in MacVim
let g:NERDTreeShowHidden=1 " Show hidden files in NERDTree by default
let g:gitgutter_highlight_lines=1 " Highlight changed lines
let g:tlTokenList=["FIXME", "TODO", "???", "XXX"]
let g:deoplete#enable_at_startup=1
let g:neomake_cpp_enable_makers=['clang']
let g:neomake_cpp_clang_args = ["-std=c++11", "-Wextra", "-Wall", "-g"]
let g:ctrlp_working_path_mode = 'rwa'

" ========
" Mappings
" ========
noremap <leader>. :CtrlPTag<cr>
map <silent> <C-f> :NERDTreeFocus<cr>
map <silent> <C-n> :NERDTreeToggle<cr>
map <leader>b :TagbarToggle<cr>
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" ========
" Autocommands
" ========
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif " Close preview window on movement or entering insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

