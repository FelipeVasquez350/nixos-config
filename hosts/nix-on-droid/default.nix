{
  ...
}:

{
  imports = [
    # Required
    ./base.nix

    # Optional But Recommended
    ./sshd.nix
  ];

  user.uid = 10197;
  user.gid = 10197;
}
