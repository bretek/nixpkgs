{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  chardet,
  humanfriendly,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  smartmontools,
}:

buildPythonPackage rec {
  pname = "pysmart";
  version = "1.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "py-SMART";
    tag = "v${version}";
    hash = "sha256-gsMFJbh2I64W1CDbwu9HUHjzS2pxsw91nD3lOYlBUEY=";
  };

  postPatch = ''
    substituteInPlace pySMART/utils.py \
      --replace "which('smartctl')" '"${smartmontools}/bin/smartctl"'
  '';

  propagatedBuildInputs = [
    chardet
    humanfriendly
  ];

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pySMART" ];

  meta = with lib; {
    description = "Wrapper for smartctl (smartmontools)";
    homepage = "https://github.com/truenas/py-SMART";
    changelog = "https://github.com/truenas/py-SMART/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
