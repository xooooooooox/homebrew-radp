# Homebrew formula template for radp-bash-framework
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/radp-bash-framework/archive/refs/tags/v0.6.32.tar.gz - GitHub archive URL for the release tag
#   cccd3611e6317e769e6c6b40cfdf74a074026ce86a40c9444244f5c2ba1670cd      - SHA256 checksum of the tarball
#   0.6.32     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install radp-bash-framework

class RadpBashFramework < Formula
  desc "Modular Bash framework with logging, configuration, and CLI toolkit"
  homepage "https://github.com/xooooooooox/radp-bash-framework"
  url "https://github.com/xooooooooox/radp-bash-framework/archive/refs/tags/v0.6.32.tar.gz"
  sha256 "cccd3611e6317e769e6c6b40cfdf74a074026ce86a40c9444244f5c2ba1670cd"
  version "0.6.32"
  license "MIT"

  def install
    # Install framework to libexec
    libexec.install Dir["src/main/shell/*"]

    # Create bin wrapper for radp-bf CLI
    (bin/"radp-bf").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/radp-bf" "$@"
    EOS

    # Install shell completions (from root completions/ directory)
    bash_completion.install "completions/radp-bf"
    zsh_completion.install "completions/_radp-bf"
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

      Shell completion has been installed automatically.
      Restart your shell or run: source ~/.bashrc (or ~/.zshrc)
    EOS
  end

  test do
    system "#{bin}/radp-bf", "version"
    system "#{bin}/radp-bf", "path", "root"
  end
end
