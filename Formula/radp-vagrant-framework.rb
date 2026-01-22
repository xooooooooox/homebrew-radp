# Homebrew formula template for radp-vagrant-framework
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.0.9.tar.gz - GitHub archive URL for the release tag
#   6b41db7dfa17ef9458d7ec6a735492448ff1e50f751757a9c3bb92f87cbe2980      - SHA256 checksum of the tarball
#   0.0.9     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install radp-vagrant-framework

class RadpVagrantFramework < Formula
  desc "YAML-driven framework for managing multi-machine Vagrant environments"
  homepage "https://github.com/xooooooooox/radp-vagrant-framework"
  url "https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "6b41db7dfa17ef9458d7ec6a735492448ff1e50f751757a9c3bb92f87cbe2980"
  version "0.0.9"
  license "MIT"

  # Use system ruby on macOS instead of forcing Homebrew's ruby
  uses_from_macos "ruby"

  def install
    # Install Ruby framework files
    libexec.install Dir["src/main/ruby/*"]

    # Install CLI script to libexec/bin and create symlink
    (libexec/"bin").install "src/main/shell/bin/radp-vf"
    bin.install_symlink libexec/"bin/radp-vf"
  end

  test do
    system "#{bin}/radp-vf", "version"
  end
end
