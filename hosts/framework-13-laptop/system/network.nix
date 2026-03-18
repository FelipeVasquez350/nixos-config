{ ... }:
{

  boot.kernelModules = [ "br_netfilter" ];

  networking.bridges."br0".interfaces = [ "enp195s0f4u1" ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.rp_filter" = 0;
    "net.ipv4.conf.default.rp_filter" = 0;
    "net.ipv4.conf.br0.rp_filter" = 0;
    "net.bridge.bridge-nf-call-iptables" = 0;
    "net.bridge.bridge-nf-call-ip6tables" = 0;
    "net.bridge.bridge-nf-call-arptables" = 0;
  };

  virtualisation.libvirtd.allowedBridges = [
    "virbr0"
    "br0"
  ];

  networking.firewall.trustedInterfaces = [ "br0" ];
  networking.firewall.allowedTCPPorts = [
    22
    5173
    3022
  ];

  networking.firewall.extraCommands = ''
    iptables -A FORWARD -i wlp1s0 -o br0 -j ACCEPT
    iptables -A FORWARD -i br0 -o wlp1s0 -j ACCEPT
  '';
}
