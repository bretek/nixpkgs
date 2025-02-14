{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  python3,
  ninja,
  gusb,
  pixman,
  glib,
  nss,
  gobject-introspection,
  cairo,
  libgudev,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  openssl,
  opencv4,
  doctest,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfprint";
  version = "1.94.8";
  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchFromGitHub {
    owner = "bretek";
    repo = "libfprint";
    rev = "39dc0e17e9ace8e0256bfe7162afde1821f10900";
    hash = "sha256-6EBMb7LK4ZqaV3EUEPizRqDOM/MrpJFpUh3VcfCaU7I=";
  };

  postPatch = ''
    #patchShebangs \
    #  tests/test-runner.sh \
    #  tests/unittest_inspector.py \
    #  tests/virtual-image.py \
    #  tests/umockdev-test.py \
    #  tests/test-generated-hwdb.sh
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    gobject-introspection
  ];

  buildInputs = [
    gusb
    pixman
    glib
    nss
    cairo
    libgudev
    openssl
    opencv4
    doctest
  ];

  mesonFlags = [
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
    # Include virtual drivers for fprintd tests
    #"-Ddrivers=all"
    "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d"
  ];

  #nativeInstallCheckInputs = [
  #  (python3.withPackages (p: with p; [ pygobject3 ]))
  #];

  # We need to run tests _after_ install so all the paths that get loaded are in
  # the right place.
  doCheck = false;

  doInstallCheck = false;

  installCheckPhase = ''
    #runHook preInstallCheck

    #ninjaCheckPhase

    #runHook postInstallCheck
  '';

  meta = {
    homepage = "https://fprint.freedesktop.org/";
    description = "Library designed to make it easy to add support for consumer fingerprint readers";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ abbradar ];
  };
})
