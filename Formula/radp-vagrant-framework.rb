# Homebrew formula template for radp-vagrant-framework
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.1.3.tar.gz - GitHub archive URL for the release tag
#   3f4d568082edc6c639329f926ffe135b7db359803e030c859412cbeadb9c4b33      - SHA256 checksum of the tarball
#   0.1.3     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install radp-vagrant-framework

class RadpVagrantFramework < Formula
  desc "YAML-driven framework for managing multi-machine Vagrant environments"
  homepage "https://github.com/xooooooooox/radp-vagrant-framework"
  url "https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "3f4d568082edc6c639329f926ffe135b7db359803e030c859412cbeadb9c4b33"
  version "0.1.3"
  license "MIT"

  # Use system ruby on macOS instead of forcing Homebrew's ruby
  uses_from_macos "ruby"

  def install
    # Install Ruby framework files
    libexec.install Dir["src/main/ruby/*"]

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
