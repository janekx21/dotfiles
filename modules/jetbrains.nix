{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    jetbrains.jdk
    jetbrains.idea-ultimate
    jetbrains.webstorm
    # jetbrains.clion
    jetbrains.rider
    # jetbrains.rust-rover
	];
	
  xdg.configFile.".ideavimrc".text = 
  #idevimrc
  ''
" Track Action ID's
" " General
" set scrolloff=5
" set linenumber
" set showmode
" set showcmd
" set visualbell
" set clipboard+=unnamed
"
" " Search settings
" set ignorecase
" set smartcase
" set incsearch
" set hlsearch
"
"
" " Plugins
" set surround
" set sneak
" set nerdtree
" set easymotion " Needs a intellij plugin AceJump and IdeaVim-EasyMotion
" set notimeout
" set which-key
"
" " witch-key config
" let g:WhichKeyDesc_display = "<leader>d Display options"
"
" let g:WhichKeyDesc_zen_mode = "<leader>dz Toggle Zen mode"
" let g:WhichKeyDesc_df_mode = "<leader>dd Toggle Distraction-Free mode"
" let g:WhichKeyDesc_fullscreen = "<leader>df Toggle full screen"
" " let g:WhichKeyDesc_<identifier> = "<keybinding> <helptext>"

let mapleader = " "

"" Vim key mapping
inoremap jk <Esc>
inoremap kj <Esc>

"" Tab navigation
nnoremap <leader>l :tabnext<CR>
nnoremap <leader>h :tabprev<CR>
nmap <leader>q <action>(CloseContent)

"" Helix bindings
nnoremap gl $
nnoremap gh ^
nnoremap gs 0
nnoremap d x
nnoremap x V
nnoremap X V
vnoremap x j
vnoremap X k

"" TODO dont replace stuff
vnoremap <leader>y "+y
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Actions
"" Comment Lines
nmap <C-c> <Action>(CommentByLineComment)
"" Leader commands
nmap <leader>/ <Action>(FindInPath)
nmap <leader>S <Action>(GotoSymbol)
nmap <leader>s <Action>(ShowNavBar)
nmap <leader>f <Action>(GotoFile)
nmap <leader>e <Action>(GotoUrlAction)
nmap <leader>r <Action>(RenameElement)
"" G commands
nmap gd <Action>(GotoDeclaration)
nmap gy <Action>(GotoTypeDeclaration)
nmap gr <Action>(ShowUsages)
"" Back and Forward navigation
nmap o <Action>(Back)
nmap i <Action>(Forward)
"" Method navigation
nmap [[ <Action>(MethodUp)
nmap ]] <Action>(MethodDown)
  '';
}
