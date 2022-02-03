lua <<EOF
local vim = vim

require('packer').startup(function()

-- ### PLUGINS ###

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
  use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'neovim/nvim-lspconfig'

end)

-- ### GENERAL SETTINGS ###

-- enable mouse for scrolling
vim.o.mouse = 'n'

-- set ',' as leader for makros
vim.g.mapleader = ','

-- copy from vim to system
vim.o.clipboard = "unnamedplus"

-- ignore upper and lowercase in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Set the behavior of tab
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

-- mappings
vim.cmd('noremap <C-b> :noh<cr>:call clearmatches()<cr>') -- clear matches Ctrl+b
map('n', 'k', 'gk')
map('n', 'j', 'gj')
map('n', '<C-h>', '<C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>>')
map('n', '<C-l>', '<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><')
map('t', '<C-h>', '<C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>>')
map('t', '<C-l>', '<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><')
map('n', '<leader>t', '<C-w>v<C-l>:terminal<CR>:set nonumber<CR>:set norelativenumber<CR>i')

-- enable truecolor, font and visuals
vim.o.termguicolors = true
vim.g.enable_bold_font = 1
vim.g.enable_italic_font = 1
vim.wo.relativenumber = true
vim.wo.number = true
vim.o.updatetime = 300
vim.o.signcolumn = 'yes'

-- ### TELESCOPE ###

map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')

--- ### LSP ###

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local servers = { 'pyright', 'rust_analyzer'}
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end

EOF

" VimL section

filetype plugin indent on
syntax on

set background=dark
let ayucolor="dark"
color ayu

highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%101v', 100)

let g:airline_theme='zenburn'
let g:airline_powerline_fonts=1    "use powerline fonts
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_extensions = []

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

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c
