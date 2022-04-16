{
  description = "libvirt & virt-manager Darwin";

  inputs = {
    nixpkgs-darwin-libvirt.url = "github:mikroskeem/nixpkgs/virt-manager-darwin";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs-darwin-libvirt, flake-utils }:
    let
      inherit (nixpkgs-darwin-libvirt) lib;

      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      pkgNames = [
        "libvirt-glib"
        "libosinfo"
        "osinfo-db"
        "osinfo-db-tools"
        "usbredir"
        "gtk-vnc"
        "vte"
        "spice-gtk"
        "libvirt"
        "virt-manager"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems
      (system:
        let
          pkgs = import nixpkgs-darwin-libvirt {
            inherit system;
          };
        in
        {
          packages = lib.listToAttrs (map (n: lib.nameValuePair n pkgs.${n}) pkgNames);
        })
    // {
      overlay = final: prev:
        if final.isDarwin then
          let
            pkgs = import nixpkgs-darwin-libvirt {
              inherit (final) system;
            };
          in
          lib.listToAttrs (map (n: lib.nameValuePair n pkgs.${n}) pkgNames)
        else { };
    };
}
