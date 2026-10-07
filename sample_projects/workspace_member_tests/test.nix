{ pkgs ? import ../../nix/nixpkgs.nix { config = { }; }
, generatedCargoNix ? ./Cargo.nix { }
}:
let
  instantiatedBuild = pkgs.callPackage generatedCargoNix { };
  lib = pkgs.lib;
  # The member is compiled from a workspace-rooted source without its tests,
  # as a workspace that cuts each crate's source does.
  withoutTests = lib.cleanSourceWith {
    src = ./.;
    filter = path: _: !(lib.hasInfix "/member/tests" path);
  };
in
instantiatedBuild.workspaceMembers.workspace_member_tests.build.override {
  runTests = true;
  testSrc = ./.;
  crateOverrides = pkgs.defaultCrateOverrides // {
    workspace_member_tests = _: {
      src = withoutTests;
      workspace_member = "member";
    };
  };
}
