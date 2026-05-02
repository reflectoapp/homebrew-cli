class Reflecto < Formula
  desc "Phone notifications in your terminal — E2E encrypted, no accounts"
  homepage "https://reflecto.app"
  version "0.0.0" # bumped by CI on every release
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-darwin-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-darwin-x64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-linux-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-linux-x64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    # The downloaded asset is a single file (the binary). Rename and install.
    bin_path = Dir.glob("reflecto-*").first
    raise "No reflecto-* binary in download" if bin_path.nil?
    bin.install bin_path => "reflecto"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reflecto --version")
  end
end
