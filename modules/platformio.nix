{ config, pkgs, ... }:

{
  home.packages = [ pkgs.platformio ];

  home.sessionVariables = {
    PLATFORMIO_HOME_DIR = "${config.home.homeDirectory}/.platformio";
    PLATFORMIO_CORE_DIR = "${config.home.homeDirectory}/.platformio/.platformio-core";
  };
}
