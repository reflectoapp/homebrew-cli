class Reflecto < Formula
  desc "Phone notifications in your terminal — E2E encrypted, no accounts"
  homepage "https://reflecto.app"
  version "0.1.2" # bumped by CI on every release
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-darwin-arm64"
      sha256 "b6b43fdf212fa3e374955e9e6644cebdf210aeff46c3e5555060b64e417a955a"
    end
    on_intel do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-darwin-x64"
      sha256 "601a4960b8f4621fce6bbb0e4dba6e076d8ad514225525626bf605f69066c240"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-linux-arm64"
      sha256 "c5e62b0198a79f139fef53dcfb6ccb299533d39a6e2220a6214a935015e50cdd"
    end
    on_intel do
      url "https://github.com/reflectoapp/reflecto-binaries/releases/download/cli-v#{version}/reflecto-linux-x64"
      sha256 "7bc222f25f81c135fb1792f74cb7537cfcb33af20559d8d4945ff064a5a724c4"
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
