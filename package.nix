{ lib
, python3Packages
, fetchPypi
, testers
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "localstripe";
  version = "1.15.10";
  pyproject = true;
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-4FVTi3hs7ln4DIbUq397Mfss8yw8vSgyDLRj/GLawiA=";
  };
  build-system = [ python3Packages.setuptools ];
  dependencies = with python3Packages; [
    aiohttp
    python-dateutil
  ];
  doCheck = false;
  passthru.tests.default = testers.runNixOSTest (import ./test.nix);
  meta = {
    homepage = "https://github.com/adrienverge/localstripe";
    description = "A fake but stateful Stripe server that you can run locally, for testing purposes.";
    license = lib.licenses.gpl3Only;
  };
})
