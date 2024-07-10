{
  description = "A very basic flake";

  inputs = {
    nix-configs.url = "github:blitz/nix-configs";
  };

  outputs = { self, nix-configs }: {

    devShells.x86_64-linux.default = let
      pkgs = nix-configs.inputs.nixpkgs.legacyPackages.x86_64-linux;
    in pkgs.mkShell {
      packages = [ pkgs.gnumake ];

      KERNEL_BUILD_DIR = "${nix-configs.nixosConfigurations.avalon.config.boot.kernelPackages.kernel.dev}";
    };
  };
}
