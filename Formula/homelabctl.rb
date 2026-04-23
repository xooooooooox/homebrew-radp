# Homebrew formula template for homelabctl
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/homelabctl/archive/refs/tags/v0.4.3.tar.gz - GitHub archive URL for the release tag
#   3b68b4abc822a63009232d0c7cf9498bdd8861571603c5a0aaf001b00fd92bb1      - SHA256 checksum of the tarball
#   0.4.3     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install homelabctl

class Homelabctl < Formula
  desc "CLI tool for managing homelab infrastructure"
  homepage "https://github.com/xooooooooox/homelabctl"
  url "https://github.com/xooooooooox/homelabctl/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "3b68b4abc822a63009232d0c7cf9498bdd8861571603c5a0aaf001b00fd92bb1"
  version "0.4.3"
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

  def post_install
    (libexec/".install-repo").write("xooooooooox/homelabctl\n")
    (libexec/".install-method").write("homebrew\n")
    (libexec/".install-version").write("v#{version}\n")
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
