# Homebrew formula template for radp-vagrant-framework
# The CI workflow uses this template and replaces placeholders with actual values.
#
# Placeholders:
#   https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.0.3.tar.gz - GitHub archive URL for the release tag
#   549deb6965967d61778da18353e71cfdde9aaaa864b0a5ff883496763c1d3953      - SHA256 checksum of the tarball
#   0.0.3     - Version number (without 'v' prefix)
#
# Installation:
#   brew tap xooooooooox/radp
#   brew install radp-vagrant-framework

class RadpVagrantFramework < Formula
  desc "YAML-driven framework for managing multi-machine Vagrant environments"
  homepage "https://github.com/xooooooooox/radp-vagrant-framework"
  url "https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "549deb6965967d61778da18353e71cfdde9aaaa864b0a5ff883496763c1d3953"
  version "0.0.3"
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
