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

    KUBECONFIG="${PROJECT_ROOT}/config/kubeconfig.dec.yml";
    TALOSCONFIG="${PROJECT_ROOT}/config/talosconfig.dec.yml";

    shellHook = ''
        ./config/decrypt.sh
    '';
}
