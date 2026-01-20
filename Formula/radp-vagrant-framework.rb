# Homebrew formula template for radp-vagrant-framework
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.0.2.tar.gz - GitHub archive URL for the release tag
#   ef0daa308d16c71185badda433dcb58d157bb7573c69b97a57c9b6e04fbf3ef5      - SHA256 checksum of the tarball
#   0.0.2     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install radp-vagrant-framework

class RadpVagrantFramework < Formula
  desc "YAML-driven framework for managing multi-machine Vagrant environments"
  homepage "https://github.com/xooooooooox/radp-vagrant-framework"
  url "https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "ef0daa308d16c71185badda433dcb58d157bb7573c69b97a57c9b6e04fbf3ef5"
  version "0.0.2"
  license "MIT"

  depends_on "ruby"

  def install
    # Install Ruby framework files
    libexec.install Dir["src/main/ruby/*"]

    # Install CLI script and create symlink
    libexec.install "src/main/shell/bin/radp-vf" => "bin/radp-vf"
    bin.install_symlink libexec/"bin/radp-vf"
  end

  test do
    system "#{bin}/radp-vf", "version"
  end
end
