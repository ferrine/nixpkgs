{
  lib,
  beam,
  callPackage,
  wxGTK32,
  stdenv,
  wxSupport ? true,
  systemd,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

let
  self = beam;

in

{
  beamLib = callPackage ../development/beam-modules/lib.nix { };

  latestVersion = "erlang_27";

  # Each
  interpreters = {

    erlang = self.interpreters.${self.latestVersion};

    # Standard Erlang versions, using the generic builder.
    #
    # Three versions are supported according to https://github.com/erlang/otp/security

    erlang_28 = self.beamLib.callErlang ../development/interpreters/erlang/28.nix {
      wxGTK = wxGTK32;
      parallelBuild = true;
      inherit wxSupport systemdSupport;
    };

    erlang_27 = self.beamLib.callErlang ../development/interpreters/erlang/27.nix {
      wxGTK = wxGTK32;
      parallelBuild = true;
      inherit wxSupport systemdSupport;
    };

    erlang_26 = self.beamLib.callErlang ../development/interpreters/erlang/26.nix {
      wxGTK = wxGTK32;
      parallelBuild = true;
      inherit wxSupport systemdSupport;
    };

    # Other Beam languages. These are built with `beam.interpreters.erlang`. To
    # access for example elixir built with different version of Erlang, use
    # `beam.packages.erlang_27.elixir`.
    inherit (self.packages.erlang)
      elixir
      elixir_1_19
      elixir_1_18
      elixir_1_17
      elixir_1_16
      elixir_1_15
      elixir_1_14
      elixir-ls
      lfe
      lfe_2_1
      ;
  };

  # Helper function to generate package set with a specific Erlang version.
  packagesWith = erlang: callPackage ../development/beam-modules { inherit erlang; };

  # Each field in this tuple represents all Beam packages in nixpkgs built with
  # appropriate Erlang/OTP version.
  packages = {
    erlang = self.packages.${self.latestVersion};
    erlang_28 = self.packagesWith self.interpreters.erlang_28;
    erlang_27 = self.packagesWith self.interpreters.erlang_27;
    erlang_26 = self.packagesWith self.interpreters.erlang_26;
  };
}
