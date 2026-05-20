class Reflecto < Formula
  desc "Phone notifications in your terminal — E2E encrypted, no accounts"
  homepage "https://reflecto.app"
  version "0.2.0" # bumped by CI on every release
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-darwin-arm64"
      sha256 "bdcb6adff7d6426c19837db47414c04237870ed5dec5822d3d4a8f717d86961b"
    end
    on_intel do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-darwin-x64"
      sha256 "24d7ea5168826d0a9f7b7b5f1cc899fceca1c2adbc41a25fdd74399a53b4de12"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-linux-arm64"
      sha256 "c63e0304e06aaf950e854d506b83c757120f9c4414d14e4fc8ce2711c4c12cc2"
    end
    on_intel do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-linux-x64"
      sha256 "ca4a75a2dcfe70e2540fd154732e0a1011f1c57a801ba30b0e93d8838f68f03c"
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
