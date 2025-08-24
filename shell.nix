let
    pkgs = import <nixpkgs> {};
    PROJECT_ROOT = builtins.toString ./.;
in
pkgs.mkShell {
    packages = [
        pkgs.age
        pkgs.cilium-cli
        pkgs.fluxcd
        pkgs.k9s
        pkgs.kubeconform
        pkgs.kubectl
        pkgs.kubernetes-helm
        pkgs.openssl
        pkgs.opentofu
        pkgs.sops
        pkgs.talosctl
    ];

    KUBECONFIG="${PROJECT_ROOT}/kubeconfig.yaml";
    TALOSCONFIG="${PROJECT_ROOT}/talosconfig.yaml";

    shellHook = '''';
}
