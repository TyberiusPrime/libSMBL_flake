{
  description = "libSMBL - systems biology markup language";

  inputs = rec {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        stdenv = pkgs.stdenv;
        fetchurl = pkgs.fetchurl;

        libSMBL = { version, hash }:
          stdenv.mkDerivation {
            pname = "libSMBL";
            version = version;

            src = fetchurl {
              url =
                "mirror://sourceforge/sbml/libsbml/${version}/stable/libSBML-${version}-core-plus-packages-src.tar.gz";
              hash = hash;
            };

            nativeBuildInputs = [
              pkgs.libxml2
              pkgs.expat
              pkgs.check
              pkgs.libiconv
              pkgs.xercesc
              pkgs.bzip2
              pkgs.zlib
              pkgs.cmake
              pkgs.swig
            ];
            CMAKE_INCLUDE_PATH = "${pkgs.libxml2.dev}/include/libxml2";

            buildInputs = [ ];
            checkInputs = [ ];

            propagatedBuildInputs = [ ];

            doCheck = false;

            meta = with pkgs.lib; {
              description = "Systems biology markup language";
              homepage = "http://sbml.org/Software/libSBML";
              license = licenses.lgpl21;
              platforms = pkgs.lib.platforms.unix;

              longDescription = ''
                LibSBML is a free, open-source programming
                library to help you read, write, manipulate, translate, and
                validate SBML files and data streams.'';
            };
          };

      in {
        defaultPackage = libSMBL {
          version = "5.19.0";
          hash = "sha256-p/Dhi+eP8OBk5M2xzYZjTQi8M75SUNtKGHi9ge64tUc=";
        };
      }

    );
}
