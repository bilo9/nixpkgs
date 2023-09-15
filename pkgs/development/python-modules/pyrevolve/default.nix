{ lib
, buildPythonPackage
, fetchFromGitHub
, contexttimer
, flake8
, setuptools
, versioneer
, cython
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyrevolve";
  version = "2.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devitocodes";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-z1G8DXG06Capd87x02zqrtYyBrX4xmJP94t4bgaR2PE=";
  };

  nativeBuildInputs = [
    cython
    flake8
    setuptools
    versioneer
  ];

  propagatedBuildInputs = [
    contexttimer
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf pyrevolve
  '';

  pythonImportsCheck = [
    "pyrevolve"
  ];

  meta = with lib; {
    homepage = "https://github.com/devitocodes/pyrevolve";
    changelog = "https://github.com/devitocodes/pyrevolve/releases/tag/v${version}";
    description = "Python library to manage checkpointing for adjoints";
    license = licenses.epl10;
    maintainers = with maintainers; [ atila ];
  };
}
