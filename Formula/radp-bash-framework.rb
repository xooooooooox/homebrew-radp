# Homebrew formula template for radp-bash-framework
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/radp-bash-framework/archive/refs/tags/v0.4.27.tar.gz - GitHub archive URL for the release tag
#   acafbc99fc35c24657100c6cefc81f67bf9ecc381f28c957a0b379e1e5b66e83      - SHA256 checksum of the tarball
#   0.4.27     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install radp-bash-framework

class RadpBashFramework < Formula
  desc "Modular Bash framework with logging, configuration, and CLI toolkit"
  homepage "https://github.com/xooooooooox/radp-bash-framework"
  url "https://github.com/xooooooooox/radp-bash-framework/archive/refs/tags/v0.4.27.tar.gz"
  sha256 "acafbc99fc35c24657100c6cefc81f67bf9ecc381f28c957a0b379e1e5b66e83"
  version "0.4.27"
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
        source "$(radp-bf --print-run)"
    EOS
  end

  test do
    system "#{bin}/radp-bf", "--version"
    system "#{bin}/radp-bf", "--print-root"
  end
end
