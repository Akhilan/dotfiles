set nocompatible
set encoding=utf-8

" pathogem.vim to load plugin bundles from ~/.vim/bundle
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" load the plugin and indent settings for the detected filetype
filetype plugin indent on


set number
set ruler
set scrolloff=3  " minimum lines of context
syntax on

" Whitespace stuff
" Would use lbr for nicer linebreaks, but can't combine with listchars.
set wrap
set softtabstop=2
set shiftwidth=2
set expandtab

set list!
set listchars=nbsp:·,tab:▸\ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault  " global search by default; /g for first match.

" Always show status bar
set laststatus=2

" Show partially typed command sequences
set showcmd

" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$']

" Command-T configuration
let g:CommandTMaxHeight=20
let g:CommandTMatchWindowAtTop=1

" Remember last location in file, but not for commit messages.
if has("autocmd")
  au BufReadPost * if &filetype !~ 'commit\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

if !exists("*s:setupWrapping")
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=72
  endfunction
endif

if !exists("*s:setupMarkup")
  function s:setupMarkup()
    call s:setupWrapping()
    map <buffer> <Leader>p :Mm <CR>
  endfunction
endif

" OS X only due to use of `open`. Adapted from
" http://vim.wikia.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line
" Uses John Gruber's URL regexp: http://daringfireball.net/2010/07/improved_regex_for_matching_urls

ruby << EOF
  def open_uri
    re = %r{(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))}

    line = VIM::Buffer.current.line

    if url = line[re]
      system("open", url)
      VIM::message(url)
    else
      VIM::message("No URI found in line.")
    end
  end
EOF

if !exists("*OpenURI")
  function! OpenURI()
    :ruby open_uri
  endfunction
endif

" make and python use real tabs
au FileType make                                     set noexpandtab
au FileType python                                   set noexpandtab

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

" Uncomment to have txt files hard-wrap automatically.
"au BufRead,BufNewFile *.txt call s:setupWrapping()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Hit S in command mode to save, as :w<CR> is a mouthful and MacVim
" Command-S is a bad habit when using terminal Vim.
" We overload a command, but use 'cc' instead anyway.
noremap S :w<CR>

" Make Y consistent with C and D - yank to end of line, not full line.
nnoremap Y y$

" Map Q to something useful (e.g. QQ to hard-break current line).
" Otherwise Q enters the twilight zone of the 'Ex' mode.
noremap Q gq

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Move by screen lines instead of file lines.
" http://vim.wikia.com/wiki/Moving_by_screen_lines_instead_of_file_lines
noremap <Up> gk
noremap <Down> gj
noremap k gk
noremap j gj

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
color blackboard

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup


" Leader

let mapleader = ","

" Un-highlight search matches
nnoremap <leader><leader> :noh<CR>

map <leader>n :NERDTreeToggle<CR>
map <leader>N :NERDTreeFind<CR>" Reveal current file

map <leader>T :CommandTFlush<CR>

" Open URL from this line (OS X only).
map <leader>u :call OpenURI()<CR>

" Ack/Quickfix windows
map <leader>q :cclose<CR>

" Opens an edit command with the path of the currently edited file filled in
map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Create a split on the given side.
" From http://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/ via joakimk.
nmap <leader><left>   :leftabove  vsp<CR>
nmap <leader><right>  :rightbelow vsp<CR>
nmap <leader><up>     :leftabove  sp<CR>
nmap <leader><down>   :rightbelow sp<CR>

" Get rid of all NERDCommenter mappings except one.
let g:NERDCreateDefaultMappings=0
map <leader>c <Plug>NERDCommenterToggle
