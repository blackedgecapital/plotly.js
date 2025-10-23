{ pkgs ? import
    (fetchTarball {
      name = "jpetrucciani-2025-10-22";
      url = "https://github.com/jpetrucciani/nix/archive/7ab4a4e89422c02c7c56a51e16e7c35e7b1a0ff9.tar.gz";
      sha256 = "1vn7k743xqbfz5vj29si2w9frsr7bkqmxrfxm1dm0zdw0iphc6q2";
    })
    { }
}:
let
  name = "plotly.js";
  node = pkgs.nodejs_24;

  tools = with pkgs; {
    cli = [
      coreutils
      nixpkgs-fmt
      libuuid
    ];
    node = [ node ];
    npm = with node.pkgs; [
      prettier
      yarn
    ];
    scripts = pkgs.lib.attrsets.attrValues scripts;
  };

  scripts = { };
  paths = pkgs.lib.flatten [ (builtins.attrValues tools) ];
  env = pkgs.buildEnv {
    inherit name paths; buildInputs = paths;
  };
in
(env.overrideAttrs (_: {
  inherit name;
  NIXUP = "0.0.6";
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (with pkgs; [ openssl zlib libuuid ]);
})) // { inherit scripts; }
