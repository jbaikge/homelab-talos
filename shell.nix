let
    pkgs = import <nixpkgs> {};
    PROJECT_ROOT = builtins.toString ./.;
in
pkgs.mkShell {
    packages = [
        pkgs.age
        pkgs.kubectl
        pkgs.openssl
        pkgs.opentofu
        pkgs.sops
        pkgs.talosctl
    ];

    KUBECONFIG="${PROJECT_ROOT}/sops/kubeconfig.dec.yml";
    TALOSCONFIG="${PROJECT_ROOT}/sops/talosconfig.dec.yml";

    shellHook = ''
        ./sops/decrypt.sh
    '';
}
