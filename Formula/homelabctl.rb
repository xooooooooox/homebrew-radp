# Homebrew formula template for homelabctl
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/homelabctl/archive/refs/tags/v0.0.2.tar.gz - GitHub archive URL for the release tag
#   b27269b8e6642e992b6d12ea87abaff0bd8a3eaa1bd3c48a90f3770e8c53395d      - SHA256 checksum of the tarball
#   0.0.2     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install homelabctl

class Homelabctl < Formula
  desc "CLI tool for managing homelab infrastructure"
  homepage "https://github.com/xooooooooox/homelabctl"
  url "https://github.com/xooooooooox/homelabctl/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "b27269b8e6642e992b6d12ea87abaff0bd8a3eaa1bd3c48a90f3770e8c53395d"
  version "0.0.2"
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
