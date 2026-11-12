{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    # Scanning / diagnostics
    dig iw

    # Basic networking
    wget curl

    # VPN / Proxy
    #tor-browser

  ];
}
