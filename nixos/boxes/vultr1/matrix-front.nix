{ config, pkgs, ... }:
{

  services.nginx = {
    virtualHosts = {
      "cyplo.dev" = {
        forceSSL = true;
        enableACME = true;
        locations."= /.well-known/matrix/server".extraConfig =
          let
            server = { "m.server" = "cyplo.dev:443"; };
          in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';

          locations."= /.well-known/matrix/client".extraConfig =
            let
              client = {
                "m.homeserver" =  { "base_url" = "https://cyplo.dev"; };
                "m.identity_server" =  { "base_url" = "https://vector.im"; };
              };
            in ''
              add_header Content-Type application/json;
              add_header Access-Control-Allow-Origin *;
              return 200 '${builtins.toJSON client}';
            '';

            locations."/".extraConfig = ''
              return 404;
            '';

            locations."/_matrix" = {
              proxyPass = "http://brix:8008"; # without a trailing /
            };
          };
        };
      };

    }
