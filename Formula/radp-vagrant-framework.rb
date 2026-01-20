class RadpVagrantFramework < Formula
  desc "YAML-driven framework for managing multi-machine Vagrant environments"
  homepage "https://github.com/xooooooooox/radp-vagrant-framework"
  url "https://github.com/xooooooooox/radp-vagrant-framework/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "33c6cf9753dbbc12e03ccd017c0eb580f791517d7ba80363865dde32b1bed839"
  version "0.0.1"
  license "MIT"

  depends_on "ruby"

  def install
    libexec.install Dir["src/main/ruby/*"]
    bin.install_symlink libexec/"bin/radp-vf"
  end

  test do
    system "#{bin}/radp-vf", "version"
  end
end
