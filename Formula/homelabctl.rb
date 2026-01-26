# Homebrew formula template for homelabctl
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/homelabctl/archive/refs/tags/v0.0.6.tar.gz - GitHub archive URL for the release tag
#   7b7ee7d3f4c5b86dcca200383721fe3d0fc0acf4739ce3c2605710d345f3da5c      - SHA256 checksum of the tarball
#   0.0.6     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install homelabctl

class Homelabctl < Formula
  desc "CLI tool for managing homelab infrastructure"
  homepage "https://github.com/xooooooooox/homelabctl"
  url "https://github.com/xooooooooox/homelabctl/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "7b7ee7d3f4c5b86dcca200383721fe3d0fc0acf4739ce3c2605710d345f3da5c"
  version "0.0.6"
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

    # Install shell completions
    bash_completion.install "completions/homelabctl.bash" => "homelabctl"
    zsh_completion.install "completions/homelabctl.zsh" => "_homelabctl"
  end

  def caveats
    <<~EOS
      homelabctl requires radp-bash-framework (installed as dependency).

      For Vagrant integration, also install radp-vagrant-framework:
        brew install radp-vagrant-framework

      Shell Completions:
        Completions are installed to Homebrew's standard directories.

        For Bash, ensure bash-completion is configured:
          brew install bash-completion@2
          # Add to ~/.bash_profile or ~/.bashrc:
          [[ -r "#{HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] && \\
            source "#{HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"

        For Zsh, rebuild completion cache after installation:
          rm -f ~/.zcompdump* ~/.cache/zsh/zcompdump*
          compinit
        Or simply restart your terminal.

        Alternative: Dynamic completion (always up-to-date):
          # Bash: Add to ~/.bashrc
          eval "$(homelabctl completion bash)"
          # Zsh: Add to ~/.zshrc
          eval "$(homelabctl completion zsh)"

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
