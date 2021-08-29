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

    sorbet() {
      local interpreter
      interpreter=${pkgs.glibc}/lib64/ld-linux-x86-64.so.2

      local sorbet
      sorbet=$(
        find .bundle -type f -executable -path '*/libexec/sorbet' | sort -n | head -1
      )

      $interpreter "$sorbet" "$@"
    }
  '';
}
