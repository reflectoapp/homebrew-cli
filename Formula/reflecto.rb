class Reflecto < Formula
  desc "Phone notifications in your terminal — E2E encrypted, no accounts"
  homepage "https://reflecto.app"
  version "0.1.0" # bumped by CI on every release
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-darwin-arm64"
      sha256 "02dc63721e8c386f905a9fbcd4ed7896b8e500fa19bfc2c45276f6041528dd50"
    end
    on_intel do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-darwin-x64"
      sha256 "5a78204f60aff9fc5f41a2f9cba091b3dc846a2fc6d48e06923ddf339dd3c73b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-linux-arm64"
      sha256 "84e706274b507438740f1532928c2e5b43f4d7c2b84da9d4e21fa42bf5780329"
    end
    on_intel do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-linux-x64"
      sha256 "373c86c2c1d3343a0f2acfc1578c215d51c7f35481b261c48801cf4cf1d15a04"
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
