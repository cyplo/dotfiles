{ config, pkgs, ... }:
{

  services.nginx = {
    virtualHosts = {
      "search.cyplo.dev" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          access_log /dev/null;
          error_log /dev/null;
          proxy_connect_timeout 60s;
          proxy_send_timeout 60s;
          proxy_read_timeout 60s;
        '';
        locations."/" = {
          proxyPass = "http://localhost:8888";
        };
      };
    };
  };

  services.searx = {
    enable = true;
  };
}

