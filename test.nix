{
  name = "localstripe";

  nodes.machine = {
    imports = [ ./module.nix ];
    services.localstripe = {
      enable = true;
      port = 8421;
    };
  };

  testScript = { nodes }:
    let
      port = toString nodes.machine.services.localstripe.port;
    in
      /* py */ ''
      machine.wait_for_unit("localstripe.service")
      machine.wait_for_open_port(${port})
      out = machine.succeed(
        "curl -sSf http://localhost:${port}/v1/customers "
        "-H 'Authorization: Bearer sk_test_xxx'"
      )
      assert '"data"' in out, f"unexpected response: {out}"
    '';
}
