{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # Monitor / peripheral control
    #ddcutil ddccontrol
    #overskride

  ];
}
