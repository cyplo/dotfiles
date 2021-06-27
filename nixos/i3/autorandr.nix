{ config, pkgs, ... }:
{

  programs.autorandr = {
    enable = true;
    hooks.postswitch = {
      "change-dpi" = ''
          case "$AUTORANDR_CURRENT_PROFILE" in
            foureighty)
              DPI=144
              ;;
            *)
              echo "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
              exit 1
          esac
          echo "changing DPI to $DPI"
          ${pkgs.xorg.xrandr}/bin/xrandr --dpi $DPI
      '';
      "restart-i3" = "sudo ${pkgs.i3}/bin/i3-msg restart";
    };
    profiles = {
      "foureighty" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0006af362300000000001b0104a51f117802f4f5a4544d9c270f505400000001010101010101010101010101010101e65f00a0a0a040503020350035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343051414e30322e33200a00b2";
        };
        config = {
          eDP-1 = {
            enable = true;
            mode = "2560x1440";
          };
        };
      };
    };
  };

}
