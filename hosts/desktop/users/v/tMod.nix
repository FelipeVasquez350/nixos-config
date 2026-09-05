{ inputs, pkgs, ... }:

# Simple but bare minimum requirements for modding with tModLoader on NixOS

let
  pinnedPkgs = import inputs.nixpkgs-rider {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      jetbrains = prev.jetbrains // {
        # My licence covers Rider 2025.2.4, so the version is pinned - but only
        # the version. Taking the whole package from nixpkgs-rider also pinned
        # its glibc (2.40), while the rest of the system is on 2.42, and nothing
        # built against 2.42 can load into a 2.40 process: GLIBC_ABI_GNU2_TLS
        # does not exist before 2.41. That broke both directions at once. Rider's
        # debugger worker could not load the system .NET's libmscordbi.so, which
        # Rider reports only as CORDBG_E_DEBUG_COMPONENT_MISSING; and matching
        # .NET back to 2.40 then stopped Mesa's Vulkan ICDs loading into the game,
        # surfacing as "No supported FNA3D driver found!".
        #
        # Overriding src/version instead builds that same Rider release against
        # the current Nixpkgs toolchain, so Rider, .NET and Mesa share a glibc.
        rider = prev.jetbrains.rider.overrideAttrs (_: {
          inherit (pinnedPkgs.jetbrains.rider) version src;
        });
      };
    })
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Audio backends that prebuilt SDL2 binaries dlopen by soname, needed when
    # such a game is launched outside an FHS wrapper - tModLoader run straight
    # from Rider, for instance. Without them SDL falls through to the OSS "dsp"
    # device, which does not exist here, and reports no audio hardware at all.
    alsa-lib
    libpulseaudio
    pipewire

    # .NET globalisation
    icu
  ];

  environment = {
    sessionVariables.DOTNET_ROOT = "${pkgs.dotnet-sdk_8}/share/dotnet/";

    systemPackages = with pkgs; [
      dotnet-sdk_8
      jetbrains.rider
      steam-run
    ];
  };
}
