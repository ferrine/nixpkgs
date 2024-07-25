{
  stdenv,
  abseil-cpp,
  absl-py,
  attrs,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  lib,
  numpy,
  pybind11,
  wrapt,
}:

buildPythonPackage rec {
  pname = "dm-tree";
  version = "0.1.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "tree";
    rev = "refs/tags/${version}";
    hash = "sha256-VvSJTuEYjIz/4TTibSLkbg65YmcYqHImTHOomeorMJc=";
  };

  patches = [
    ./0001-don-t-rebuild-abseil.patch
    ./0002-don-t-fetch-pybind11.patch
    ./0003-do-not-use-apple-if-in-cmake.patch
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pybind11
  ];

  buildInputs = [
    abseil-cpp
    pybind11
  ];

  nativeCheckInputs = [
    absl-py
    attrs
    numpy
    wrapt
  ];

  pythonImportsCheck = [ "tree" ];

  meta = with lib; {
    description = "Tree is a library for working with nested data structures";
    homepage = "https://github.com/deepmind/tree";
    license = licenses.asl20;
    maintainers = with maintainers; [
      samuela
      ndl
    ];
  };
}
