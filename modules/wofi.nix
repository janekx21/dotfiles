{ pkgs, lib, ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      hide_scroll=true;
      show="drun";
      width="30%";
      lines=12;
      dynamic_lines=false;
      line_wrap="word";
      term="kitty";
      allow_markup=true;
      always_parse_args=false;
      show_all=false;
      print_command=true;
      layer="overlay";
      allow_images=true;
      sort_order="default";
      gtk_dark=true;
      # prompt=;
      image_size=24;
      display_generic=true;
      location="center";
      key_expand="Tab";
      insensitive=true;
    };

    style = 
      #css
      ''
      * {
        font-family: JetBrainsMono;
        background: transparent;
        border: none;
        outline: none;
      }

      window {
        margin: 0px;
        /* border: 1px solid #bd93f9; */
        background-color: #000;
        border-radius: 24px;
      }

      #outer-box {
        margin: 5px;
        border: none;
        /*background-color: green; */
      }

      #input {
        margin: 5px;
        color: black;
        background-color: white;
        border-radius: 18px;
      }

      #inner-box {
        margin: 5px;
        border: none;
        /*background-color: red;
        */
        /* #282a36; */
      }


      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        /*color: #f8f8f2;*/
      }

      #entry {
        border-radius: 18px;
      }

      #entry:selected {
        background-color: #212121;
        color: white;
      }

      #entry:selected #text {
        font-weight: bold;
      }

      /*
      #entry:focus {
        border: 1px solid red;
      }
      */

      #entry>* {
        color: #f8f8f2;
      }
    '';
  };
}
