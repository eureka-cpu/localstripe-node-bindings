{ config, lib, pkgs, ... }:
let
  cfg = config.services.localstripe;

  args = lib.escapeShellArgs (
    [ "--port" (toString cfg.port) ]
    ++ lib.optional cfg.fromScratch "--from-scratch"
  );
in
{
  options.services.localstripe = {
    enable = lib.mkEnableOption "localstripe stateful Stripe test server";

    package = lib.mkPackageOption pkgs "localstripe" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8420;
      description = "Port for localstripe to listen on.";
    };

    fromScratch = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start with an empty state on each launch rather than persisting across restarts.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.localstripe = {
      description = "localstripe";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/localstripe ${args}";
        DynamicUser = true;
        StateDirectory = "localstripe";
        WorkingDirectory = "/var/lib/localstripe";
        Restart = "on-failure";
      };
    };
  };
}
