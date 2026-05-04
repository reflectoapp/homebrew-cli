class Reflecto < Formula
  desc "Phone notifications in your terminal — E2E encrypted, no accounts"
  homepage "https://reflecto.app"
  version "0.1.1" # bumped by CI on every release
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-darwin-arm64"
      sha256 "58c8913306ca5ac009fde477b0a097eab08fbfb875b9ad258758a68e3ceaf19a"
    end
    on_intel do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-darwin-x64"
      sha256 "a144e816c9e39ac490d213928c99a9b9c55aab86e8105e64c0e528adebe49c09"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-linux-arm64"
      sha256 "dfc1de17c474eedb7feabc82f150af544572f5a2266b054b04a58a31d01e4d2c"
    end
    on_intel do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-linux-x64"
      sha256 "0fa3232523c5d1285b243b9635c022a76c6b9c6a270379d05dddd295cc8e10e5"
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
