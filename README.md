# Localstripe Node Bindings

Nix bindings for the localstripe stateful Stripe test server.

## Usage

The intention is to run localstripe as a node in a nixos test, however,
the package itself can be used locally as well, of course.

> [!NOTE]
> The following example is simplified for brevity. See [test.nix](./test.nix) for
> a working example:
>
> ```sh
> nix-build -A passthru.tests.default
> ```

```nix
let
  inputs = import ./sources { };
  # Instantiate nixpkgs with the overlay.nix in this repo:
  pkgs = import inputs.nixpkgs {
    overlays = [ (import "${inputs.localstripe}/overlay.nix") ];
  };
in
{
  test = pkgs.testers.runNixOSTest {
    # Add the module.nix to the imports of your nixos test node:
    nodes.stripe = {
      imports = [ "${inputs.localstripe}/module.nix" ];
      # Configure localstripe:
      services.localstripe = {
        enable = true;
        port = 8421;
      };
    };
    # ...
  };
}
```
