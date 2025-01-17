{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst-lsp";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "nvarner";
    repo = "typst-lsp";
    rev = "v${version}";
    hash = "sha256-rsG7YZjy4UgFGsehlslsrOAD5YMpVVBI2MERlxgniVA=";
  };

  patches = [
    # git information isn't available with fetchFromGitHub
    # https://github.com/nvarner/typst-lsp/pull/303
    (fetchpatch {
      name = "fix-build-when-git-information-is-not-available.patch";
      url = "https://github.com/nvarner/typst-lsp/commit/420de6235eb1aa492337a8cc43b04134a3ffab00.patch";
      hash = "sha256-Rs9pzSUg4YNGzYnX8tbOmCwbPyZ9P18Eyg451fa2Iqg=";
    })
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-0.8.0" = "sha256-q2b/PoNwpzarJbIPzokYgZRD2/Oe/XB40C4VXdwL/NA=";
      "typst-syntax-0.7.0" = "sha256-yrtOmlFAKOqAmhCP7n0HQCOQpU3DWyms5foCdUb9QTg=";
      "typstfmt_lib-0.2.4" = "sha256-d0vlZqg0RcRvZM7xYdMLX2/UeolUbqZ9H4drJRRKBmc=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # requires internet access
    "--skip=workspace::package::external::remote_repo::test::full_download"
  ];

  # workspace::package::external::manager::test::local_package tries to access the data directory
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "A brand-new language server for Typst";
    homepage = "https://github.com/nvarner/typst-lsp";
    changelog = "https://github.com/nvarner/typst-lsp/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda GaetanLepage ];
  };
}
