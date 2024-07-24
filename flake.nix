{
  description = "A very basic flake";

  inputs = {
    nix-configs.url = "github:blitz/nix-configs";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs = { self, nix-configs, ... }: let
    pkgs = nix-configs.inputs.nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = [ pkgs.gnumake self.packages.x86_64-linux.kpatch ];

      KERNEL_BUILD_DIR = "${nix-configs.nixosConfigurations.avalon.config.boot.kernelPackages.kernel.dev}";
    };

    packages.x86_64-linux = {
      kpatch = pkgs.callPackage ./kpatch.nix {};

      hotpatch = pkgs.callPackage ./hotpatch.nix {
        kernel = nix-configs.nixosConfigurations.avalon.config.boot.kernelPackages.kernel;
        patch = ./0001-XXX-kvm-cpuid-patch.patch;

        inherit (self.packages.x86_64-linux) kpatch;
      };
    };
  };
}
