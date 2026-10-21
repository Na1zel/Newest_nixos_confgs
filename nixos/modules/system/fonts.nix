{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    cantarell-fonts
    material-symbols
    nerd-fonts.caskaydia-cove
    terminus_font
  ];
}
