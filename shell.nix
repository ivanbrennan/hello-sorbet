let
  rev = "a7f1e9f1efbebd657a27d12ecd605a35ac4088d4";
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    sha256 = "08rwlvp9xmzm0yq121zj9zvnfbxs08pzmkxlspqrs9kyl14x7ypy";
  }) {
    overlays = [
      (self: super: { ruby = self.ruby_2_7; })
    ];
  };

in pkgs.mkShell {
  buildInputs = [
    pkgs.bundler
    pkgs.ruby
  ];
  shellHook = ''
    export BUNDLE_PATH=.bundle
    export NIX_ENFORCE_PURITY=0

    patch_sorbet() {
      local patchelf
      patchelf=${pkgs.patchelf}/bin/patchelf

      local interpreter
      interpreter=${pkgs.glibc}/lib64/ld-linux-x86-64.so.2

      local sorbet
      for sorbet in $(find .bundle -type f -executable -path '*/libexec/sorbet')
      do
          chmod 755 "$sorbet" && $patchelf --set-interpreter $interpreter "$sorbet"
          chmod 555 "$sorbet"
      done
    }
  '';
}
