" General {{{

" Sets how many lines of history VIM has to remember
let mapleader = ","            " set leader key to ,
let maplocalleader = "\\"      " set local leader to \

set history=500

filetype plugin indent on      " Enable filteype plugins
set autoread                   " Set to auto read when a file is changed from the outside
set modelines=1                " Allow vim options to be embedded in files
set mouse=a                    " Enable mouse
set scrolloff=7                       " Set 7 lines to the cursor - when moving vertically using j/k

set ruler                      " Always show current position

set cmdheight=2                " Height of the command bar

set mat=2 " How many tenths of a second to blink when matching brackets

set backspace=eol,start,indent " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l         " Allow characters to wrap to new lines
set noerrorbells               " No annoying sound on errors
set novisualbell
set t_vb=
set tm=500

" }}}
" Plugins {{{

call plug#begin('~/.vim/plugged')

" Automatically install plugins if plugin folder not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent call system('mkdir -p ~/.vim/{autoload,bundle,cache,undo,backups,swaps}')
  silent call system('curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  execute 'source  ~/.vim/autoload/plug.vim'
  augroup plugsetup
    au!
    autocmd VimEnter * PlugInstall
  augroup end
endif

call plug#begin('~/.vim/plugged')

"asynchronous code linting
Plug 'w0rp/ale'

" Features
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

" Programming
Plug 'sheerun/vim-polyglot'
Plug 'jalvesaq/nvim-r'

" Writing
Plug 'lervag/vimtex'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'rhysd/vim-grammarous'
Plug 'reedes/vim-pencil'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-wordy'
Plug 'reedes/vim-lexical'
Plug 'dpelle/vim-LanguageTool'
Plug 'dpelle/vim-Grammalecte'
Plug 'ron89/thesaurus_query.vim'

" UI
Plug 'itchyny/lightline.vim'
Plug 'NovaDev94/lightline-onedark'
Plug 'chriskempson/base16-vim'
Plug 'joshdick/onedark.vim'


call plug#end()
" }}}
" Colors {{{ 

" Enable syntax highlighting
syntax enable 

" Set background to match terminal background
autocmd ColorScheme * highlight! Normal ctermbg=NONE guibg=NONE

"enable 256 color support
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
else
    colorscheme onedark
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8
set fileencoding=utf-8

" set airline theme
let g:airline_theme='onedark'
" }}}
" UI {{{ 

" Relative line numbering
set relativenumber
set number

" Turn on the Wild menu
set wildmenu
set wildmode=longest:list,full

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" Show matching brackets when text indicator is over them
set showmatch 

" Don't show a fold column
set foldcolumn=0

" Set cursor to i-beam in insert mode
" Konsole
"let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" }}}
" Search {{{

set ignorecase " Ignore case when searching
set smartcase  " When searching try to be smart about cases

set hlsearch   " Highlight search results
set incsearch  " Makes search act like search in modern browsers
if has("nvim")
    set inccommand=split
endif

" Unset the 'last search pattern' register by hitting return
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

set magic    " For regular expressions turn magic on

set gdefault " Set substitution to global by default

" }}}
" Folding {{{

" enable folding
set nofoldenable
set foldmethod=syntax
set foldlevelstart=99

"}}}
" Files, backups and undo {{{
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set noswapfile

"Keep undo history across sessions
if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
    silent !mkdir ~/.vim/backups > /dev/null 2>&1
    set undodir=~/.vim/backups
    set undofile
endif

nnoremap <Space>w :w<CR>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

" }}}
" Text, tab and indent {{{
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set linebreak "Don't break halfway through words
set nolist

"}}}
" Visual mode {{{
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" }}}
" Tabs, windows, buffers {{{

set hidden                     " A buffer becomes hidden when it is abandoned

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Open file with <Space>t
nnoremap <Space>t :Files<CR>

" Switch functionality of 0 and ^
nnoremap 0 ^
nnoremap ^ 0

" Switch buffers with <Space>b
nnoremap <Space>b :Buffers<CR> 

nnoremap <Space>z :bp<CR>
nnoremap <Space>x :bn<Cr>

" }}}
" Insert mode {{{

"}}}
" Normal mode mappings {{{
nnoremap c* *``cgn
nnoremap c# #``cgn
"}}}
" Language {{{
" Set language keymap
nmap <silent> <Bslash>e :setlocal spell! spelllang=en_ca<CR>
nmap <silent> <Bslash>f :setlocal spell! spelllang=fr<CR>

" Grammarous mappings
nmap <Space>f <Plug>(grammarous-fixit)
nmap <Space>n <Plug>(grammarous-move-to-next-error)
nmap <Space>p <Plug>(grammarous-move-to-previous-error)

" }}}
" Plugins {{{

" Vimtex
" Set default pdf-viewer
let g:tex_flavor = 'latex'
let g:tex_conceal = ''
let g:vimtex_fold_manual = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_compiler_progname = 'nvr'
let g:polyglot_disabled = ['latex']

nnoremap <Bslash>cw :VimtexCountWords<CR>

" UltiSnips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'

let g:UltiSnipsSnippetsDir = "~/.config/nvim/snippets"

" CoC

"Easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Vim Pandoc
" let g:pandoc#command#autoexec_on_writes = 1
" let g:pandoc#command#autoexec_command = "Pandoc pdf -Vmainfont='Open Sans'"
" let g:pandoc#command#custom_open = "PandocOpenFile"
" let g:pandoc#command#prefer_pdf = 1
nnoremap <Space>y :silent !zathura %:r.pdf &<CR>

" limelight
let g:limelight_conceal_ctermfg = 240
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" lightline
let g:lightline =
    \ {
    \ 'colorscheme': 'onedark',
    \ }

" goyo
let g:goyo_width = 74
nnoremap <Space>g :Goyo <CR>

" Vim Pencil
let g:pencil#wrapModeDefault = 'soft'
let g:airline_section_x = '%{PencilMode()}'
let g:pencil#conceallevel=1

" grammarous
let g:grammarous#use_vim_spelllang = 1

" grammalecte
let g:grammalecte_cli_py='/usr/local/Grammalecte/pythonpath/grammalecte-cli.py'

" Thesaurus query
nnoremap <Bslash>t :ThesaurusQueryReplaceCurrentWord<CR>

let g:tq_enabled_backends=["thesaurus_com","openoffice_en","datamuse_com","mthesaur_txt"]

" }}}
" Custom functions {{{

""" Prose writing
function! Prose()
    call pencil#init({'wrap': 'soft'})
    call lexical#init()
    
    set conceallevel=1

    " manual reformatting shortcuts
    nnoremap <buffer> <silent> Q gqap
    xnoremap <buffer> <silent> Q gq
    nnoremap <buffer> <silent> <leader>Q vapJgqap
    
    nnoremap <expr> j v:count ? 'j' : 'gj'
    nnoremap <expr> k v:count ? 'k' : 'gk'

    " Fix last spelling error with <C-L>
    inoremap <C-L> <c-g>u<Esc>[s1z=`]a<c-g>u

endfunction

" automatically initialize buffer by file type
autocmd FileType markdown,tex,mkd,text,rst call Prose()

" invoke manually by command for other file types
command! -nargs=0 Prose call Prose()

" }}}
" vim:foldmethod=marker:foldlevel=0
