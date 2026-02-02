# Homebrew formula template for radp-vagrant-framework
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.2.19.tar.gz - GitHub archive URL for the release tag
#   d9fd2408b04055532d239b048d975d634ec1e5f6816d245eea8ca9c082dda1d3      - SHA256 checksum of the tarball
#   0.2.19     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install radp-vagrant-framework

class RadpVagrantFramework < Formula
  desc "YAML-driven framework for managing multi-machine Vagrant environments"
  homepage "https://github.com/xooooooooox/radp-vagrant-framework"
  url "https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.2.19.tar.gz"
  sha256 "d9fd2408b04055532d239b048d975d634ec1e5f6816d245eea8ca9c082dda1d3"
  version "0.2.19"
  license "MIT"

  # Use system ruby on macOS instead of forcing Homebrew's ruby
  uses_from_macos "ruby"

  # Requires radp-bash-framework for CLI
  depends_on "xooooooooox/radp/radp-bash-framework"

  def install
    # Install Ruby framework files
    libexec.install Dir["src/main/ruby/*"]

    # Install shell CLI layer
    (libexec/"src/main/shell").install Dir["src/main/shell/*"]

    # Install project templates
    libexec.install "templates"

    # Install CLI script to libexec/bin and create symlink
    (libexec/"bin").install "bin/radp-vf"
    bin.install_symlink libexec/"bin/radp-vf"

    # Install shell completions
    bash_completion.install "completions/radp-vf.bash" => "radp-vf"
    zsh_completion.install "completions/radp-vf.zsh" => "_radp-vf"
  end

  def caveats
    <<~EOS
      radp-vagrant-framework requires Vagrant and a provider (e.g., VirtualBox).

      To install dependencies:
        brew install --cask vagrant
        brew install --cask virtualbox

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

      Quick start:
        radp-vf init myproject
        cd myproject
        radp-vf vg status

      For a richer CLI experience, consider using homelabctl:
        brew install homelabctl
    EOS
  end

  test do
    system "#{bin}/radp-vf", "version"
  end
end
