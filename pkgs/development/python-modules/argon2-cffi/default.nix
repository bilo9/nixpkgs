{ argon2-cffi-bindings
, buildPythonPackage
, fetchPypi
, hatch-fancy-pypi-readme
, hatchling
, hatch-vcs
, hypothesis
, lib
, pytestCheckHook
, stdenv
}:

buildPythonPackage rec {
  pname = "argon2-cffi";
  version = "23.1.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "argon2_cffi";
    inherit version;
    hash = "sha256-h5w+eaJynOdo67fTbUYJ46eKTKLsOp8SKGygV+PQ2wg=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [
    argon2-cffi-bindings
  ];

  env.ARGON2_CFFI_USE_SSE2 = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) "0";

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Secure Password Hashes for Python";
    homepage    = "https://argon2-cffi.readthedocs.io/";
    license     = licenses.mit;
  };
}
