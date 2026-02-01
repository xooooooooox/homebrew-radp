# Homebrew formula template for homelabctl
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/homelabctl/archive/refs/tags/v0.1.25.tar.gz - GitHub archive URL for the release tag
#   8a915a734ee02ddb82cab1eec47f7e3984fc431785dcfcf04f39e55de18bb1b7      - SHA256 checksum of the tarball
#   0.1.25     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install homelabctl

class Homelabctl < Formula
  desc "CLI tool for managing homelab infrastructure"
  homepage "https://github.com/xooooooooox/homelabctl"
  url "https://github.com/xooooooooox/homelabctl/archive/refs/tags/v0.1.25.tar.gz"
  sha256 "8a915a734ee02ddb82cab1eec47f7e3984fc431785dcfcf04f39e55de18bb1b7"
  version "0.1.25"
  license "MIT"

  depends_on "xooooooooox/radp/radp-bash-framework"

  def install
    # Install to libexec, excluding IDE support files
    libexec.install "bin"
    libexec.install "src"

    # Remove IDE support files (development only, not needed at runtime)
    Dir.glob(libexec/"src/**/_ide*.sh").each { |f| rm f }

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
        Completions are installed to: #{HOMEBREW_PREFIX}/share/zsh/site-functions/

        For standard Zsh setup (recommended):
          # Rebuild completion cache
          rm -f ~/.zcompdump* && compinit
          # Or restart your terminal

        For Zinit users:
          # Option 1: Add Homebrew's site-functions to fpath (before zinit init)
          fpath=(#{HOMEBREW_PREFIX}/share/zsh/site-functions $fpath)

          # Option 2: Use zinit snippet
          zinit ice as"completion"
          zinit snippet #{HOMEBREW_PREFIX}/share/zsh/site-functions/_homelabctl

        For Oh-My-Zsh users:
          ln -sf #{HOMEBREW_PREFIX}/share/zsh/site-functions/_homelabctl \
            ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/homelabctl/_homelabctl

        For Bash:
          brew install bash-completion@2
          # Add to ~/.bash_profile or ~/.bashrc:
          [[ -r "#{HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] && \
            source "#{HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"

        Alternative - Dynamic completion (always up-to-date):
          # Bash: eval "$(homelabctl completion bash)"
          # Zsh:  eval "$(homelabctl completion zsh)"

      Quick start:
        homelabctl --help
    EOS
  end

  test do
    # Basic test - check if help works
    system "#{bin}/homelabctl", "--help"
  end
end
