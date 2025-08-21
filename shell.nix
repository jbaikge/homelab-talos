let
    pkgs = import <nixpkgs> {};
    PROJECT_ROOT = builtins.toString ./.;
in
pkgs.mkShell {
    packages = [
        pkgs.age
        pkgs.k9s
        pkgs.kubectl
        pkgs.kubernetes-helm
        pkgs.openssl
        pkgs.opentofu
        pkgs.sops
        pkgs.talosctl
    ];

    KUBECONFIG="${PROJECT_ROOT}/config/kubeconfig.yaml";
    TALOSCONFIG="${PROJECT_ROOT}/config/talosconfig.yaml";

    shellHook = '''';
}
