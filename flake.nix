{
    description = "Owl for Exchange (Cracked License)";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";

        original-owl = {
            url = "https://www.beonex.com/owl/owl.xpi";
            flake = false;
        };
    };

    outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in rec {
            licensePatch = builtins.readFile ./license-patch.js;

            defaultPackage = pkgs.stdenvNoCC.mkDerivation {
                name = "owl-exchange";
                src = inputs.original-owl;
                unpackPhase = ''
                    ${pkgs.unzip}/bin/unzip $src
                '';
                patchPhase = ''
                    echo "${licensePatch}" >> license.js
                '';
                dontConfigure = true;
                buildPhase = ''
                    ${pkgs.zip}/bin/zip -r owl.xpi *
                '';
                installPhase = ''
                    mkdir -p $out/addon
                    cp owl.xpi $out/addon/
                '';
            };
        }
    );
}
