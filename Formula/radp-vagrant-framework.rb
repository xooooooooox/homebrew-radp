# Homebrew formula template for radp-vagrant-framework
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.0.22.tar.gz - GitHub archive URL for the release tag
#   f575b8dcce6140416e30a6d4cae726480f5c7a25f7b266decacebd134e0f5fa1      - SHA256 checksum of the tarball
#   0.0.22     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install radp-vagrant-framework

class RadpVagrantFramework < Formula
  desc "YAML-driven framework for managing multi-machine Vagrant environments"
  homepage "https://github.com/xooooooooox/radp-vagrant-framework"
  url "https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "f575b8dcce6140416e30a6d4cae726480f5c7a25f7b266decacebd134e0f5fa1"
  version "0.0.22"
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
    EOS
  end

  test do
    system "#{bin}/radp-vf", "version"
  end
end
