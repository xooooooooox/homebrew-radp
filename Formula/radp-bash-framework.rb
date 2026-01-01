# frozen_string_literal: true

class RadpBashFramework < Formula
  desc "Modular Bash framework with preflight checks and structured context"
  homepage "https://github.com/xooooooooox/radp-bash-framework"
  url "https://github.com/xooooooooox/radp-bash-framework/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "dc743605f165f0fe039d4fb7c7c9c7db8f65661379888750a4ab403ddfad9390"
  license "MIT"

  def install
    # Support both a Maven-style layout (src/main/shell/...) and a top-level layout.
    framework_src = if Pathname("src/main/shell/framework").exist?
      "src/main/shell/framework"
    else
      "framework"
    end

    radp_bf_src = if Pathname("src/main/shell/bin/radp-bf").exist?
      "src/main/shell/bin/radp-bf"
    else
      "bin/radp-bf"
    end

    libexec.install framework_src
    libexec.install Pathname(radp_bf_src).dirname

    # Keep the real script under libexec so it can locate its root (.. from bin).
    bin.install_symlink libexec/"bin/radp-bf"
  end

  test do
    assert_match "framework", shell_output("#{bin}/radp-bf --print-root")
  end
end
