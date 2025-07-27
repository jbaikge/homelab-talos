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

    KUBECONFIG="${PROJECT_ROOT}/files/kubeconfig.yml";
    TALOSCONFIG="${PROJECT_ROOT}/files/talosconfig.yml";

    shellHook = ''
        sops decrypt --output files/kubeconfig.yml files/kubeconfig.age.yml
        sops decrypt --output files/talosconfig.yml files/talosconfig.age.yml
        sops decrypt --output files/secrets.yml files/secrets.age.yml
    ''
}
