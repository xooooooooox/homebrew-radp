# frozen_string_literal: true

class RadpBashFramework < Formula
  desc "Modular Bash framework with preflight checks and structured context"
  homepage "https://github.com/xooooooooox/radp-bash-framework"
  url "https://github.com/xooooooooox/radp-bash-framework/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "dc743605f165f0fe039d4fb7c7c9c7db8f65661379888750a4ab403ddfad9390"
  license "MIT"

  def install
    libexec.install Dir["src/main/shell/framework"]
    bin.install "bin/radp-bf"
  end

  test do
    assert_match "framework", shell_output("#{bin}/radp-bf --print-root")
  end
end
