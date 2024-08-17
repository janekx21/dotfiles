{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    jetbrains.jdk
    jetbrains.idea-ultimate
    jetbrains.webstorm
	];
	
  xdg.configFile.".ideavimrc".text = 
  #idevimrc
  ''
    " General
    set scrolloff=5
    set linenumber
    set showmode
    set showcmd
    set visualbell
    set clipboard+=unnamed

    " Search settings 
    set ignorecase
    set smartcase
    set incsearch
    set hlsearch

    let mapleader = " "

    " Plugins
    set surround
    set sneak
    set nerdtree
    set easymotion " Needs a intellij plugin AceJump and IdeaVim-EasyMotion
    set notimeout
    set which-key

    " witch-key config
    let g:WhichKeyDesc_display = "<leader>d Display options"

    let g:WhichKeyDesc_zen_mode = "<leader>dz Toggle Zen mode"
    let g:WhichKeyDesc_df_mode = "<leader>dd Toggle Distraction-Free mode"
    let g:WhichKeyDesc_fullscreen = "<leader>df Toggle full screen"
    " let g:WhichKeyDesc_<identifier> = "<keybinding> <helptext>"

    " Key mapping
    inoremap jk <Esc>

    "" Tab navigation
    nnoremap <leader>l :tabnext<CR>
    nnoremap <leader>h :tabprev<CR>\

    "" Comment lines
    map <C-c> <action>(CommentByLineComment)
  '';
}
