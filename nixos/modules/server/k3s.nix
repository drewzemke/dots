{ unstable, ... }:

{
  services.k3s = {
    enable = true;
    role = "server";
    package = unstable.k3s_1_35;
    extraFlags = toString [
      "--disable=servicelb"
      "--disable=traefik"
    ];
  };

  # k3s data lives on its own SSD
  fileSystems."/var/lib/rancher/k3s" = {
    device = "/dev/disk/by-uuid/a2843146-ec37-4b8c-a824-00d2942dd718";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  systemd.services.k3s.unitConfig = {
    RequiresMountsFor = "/var/lib/rancher/k3s";
  };

  environment.sessionVariables.KUBECONFIG = "/home/drew/.kube/config";
}
