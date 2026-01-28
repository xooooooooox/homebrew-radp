# Homebrew formula template for radp-bash-framework
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/radp-bash-framework/archive/refs/tags/v0.6.5.tar.gz - GitHub archive URL for the release tag
#   159723c2d6f5718dbecaf0f5048c646ac9d704cfc86ca7641195a9f81320b4d1      - SHA256 checksum of the tarball
#   0.6.5     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install radp-bash-framework

class RadpBashFramework < Formula
  desc "Modular Bash framework with logging, configuration, and CLI toolkit"
  homepage "https://github.com/xooooooooox/radp-bash-framework"
  url "https://github.com/xooooooooox/radp-bash-framework/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "159723c2d6f5718dbecaf0f5048c646ac9d704cfc86ca7641195a9f81320b4d1"
  version "0.6.5"
  license "MIT"

  def install
    # Install framework to libexec
    libexec.install Dir["src/main/shell/*"]

    # Create bin wrapper for radp-bf CLI
    (bin/"radp-bf").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/radp-bf" "$@"
    EOS
  end

  def caveats
    <<~EOS
      radp-bash-framework has been installed to:
        #{libexec}

      The CLI wrapper 'radp-bf' is available in your PATH.

      Quick start:
        radp-bf --help
        radp-bf new mycli    # Create a new CLI project

      To use the framework in your scripts:
        source "$(radp-bf path init)"
    EOS
  end

  test do
    system "#{bin}/radp-bf", "--version"
    system "#{bin}/radp-bf", "--print-root"
  end
end
