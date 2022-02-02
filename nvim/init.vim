" ##############################################################################
" PLUGING
" ##############################################################################

lua <<EOF
return require('packer').startup(function()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- managing bracktes of all sort
  use 'jiangmiao/auto-pairs'
  -- status bar
  use 'vim-airline/vim-airline'
  -- status bar themes
  use 'vim-airline/vim-airline-themes'
  -- colortheme
  use 'kristijanhusak/vim-hybrid-material'
  use 'ayu-theme/ayu-vim'

  -- Telescope search
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'

end)
EOF

" ##############################################################################
" EDITOR BASICS
" ##############################################################################

" enable mouse for scrolling
set mouse=n
" key for new makros
let mapleader = ","

" language for spell chacking
set spelllang=de,en
filetype plugin indent on
syntax on

" ignore upper- or lowercase in search model
" if there is uppercase in search string ignore 'ignorecase' setting
set ignorecase
set smartcase
set clipboard+=unnamedplus

" configure tabwidth and insert spaces instead of tabs
set tabstop=2        " tab width is 4 spaces
set shiftwidth=2     " indent also with 4 spaces
set expandtab        " expand tabs to spaces

" removes marks after search
nmap <F1> :noh<CR>
" removes marks after search (for insert-mode)
imap <F1> <ESC>:noh<CR>i
" saves file
nmap <F2> :w<CR>
" saves file in (insert-mode)
imap <F2> <ESC>:w<CR>i

" navigation by visible lines (not logical)
map k gk
map j gj

" switching splittscreens
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l
" increase and decrease splittsreen size
noremap <leader>h <C-W><
noremap <leader>l <C-W>>

" Buffers opens
nnoremap <leader>b :Buffers<cr>());

"spell checking
map <leader>ss :setlocal spell!<CR>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"terminal mappings
map <leader>t <C-w>v<C-l>:terminal<CR>:set nonumber<CR>:set norelativenumber<CR>i

tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

" ##############################################################################
" EDITOR VISUAL BASICS
" ##############################################################################

" enable truecolor
set termguicolors

" set colortheme settings
let g:enable_bold_font = 1
let g:enable_italic_font = 1
" let g:hybrid_transparent_background = 1
set background=dark
" let ayucolor="mirage"
let ayucolor="dark"
color ayu

" relative numberline
set number relativenumber

" subtle mark for lines over 80 characters
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%101v', 100)

" ##############################################################################
" SEARCH SETTINGS
" ##############################################################################

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fk :lua require'telescope.builtin'.oldfiles{}<cr>

" ##############################################################################
" SETTINGS FOR AIRLINE
" ##############################################################################

" let g:airline_theme='wombat' 
let g:airline_theme='zenburn'
let g:airline_powerline_fonts=1    "use powerline fonts
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_extensions = []

" unicode symbols
" removes weird arrow shapes in status bar
" and ugly unicode symbols

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = ' '
let g:airline_left_sep = ' '
let g:airline_right_sep = ' '
let g:airline_right_sep = ' '
let g:airline_symbols.crypt = ' '
let g:airline_symbols.linenr = ' '
let g:airline_symbols.linenr = ' '
let g:airline_symbols.linenr = ' '
let g:airline_symbols.linenr = ' '
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = ' '
let g:airline_symbols.branch = ' '


" ##############################################################################
" SETTINGS FOR LSP
" ##############################################################################

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)
" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
"
" Show diagnostic popup on cursor hold
" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes
