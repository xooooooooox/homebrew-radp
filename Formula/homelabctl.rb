# Homebrew formula template for homelabctl
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/homelabctl/archive/refs/tags/v0.0.4.tar.gz - GitHub archive URL for the release tag
#   1e5a8af214ff777ba705c1b1fa2b04c3039e9656926ce51338930727f814eb77      - SHA256 checksum of the tarball
#   0.0.4     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install homelabctl

class Homelabctl < Formula
  desc "CLI tool for managing homelab infrastructure"
  homepage "https://github.com/xooooooooox/homelabctl"
  url "https://github.com/xooooooooox/homelabctl/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "1e5a8af214ff777ba705c1b1fa2b04c3039e9656926ce51338930727f814eb77"
  version "0.0.4"
  license "MIT"

  depends_on "xooooooooox/radp/radp-bash-framework"

  def install
    # Install to libexec
    libexec.install "bin", "src"

    # Create wrapper script that sets up paths
    (bin/"homelabctl").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/homelabctl" "$@"
    EOS
  end

  def caveats
    <<~EOS
      homelabctl requires radp-bash-framework (installed as dependency).

      For Vagrant integration, also install radp-vagrant-framework:
        brew install radp-vagrant-framework

      Quick start:
        homelabctl --help
        homelabctl vf init myproject
        homelabctl vg status
    EOS
  end

  test do
    # Basic test - check if help works
    system "#{bin}/homelabctl", "--help"
  end
end
