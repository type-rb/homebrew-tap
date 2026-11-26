class Trbg < Formula
  desc "Go implementation of TypeRB"
  homepage "https://github.com/type-rb/type-rb-go"
  version "0.5.0-alpha.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb-go/releases/download/v0.5.0-alpha.2/trbg_0.5.0-alpha.2_darwin_arm64.tar.gz"
      sha256 "0f38356e4319c37493744aecd3b496c214191970f659935058601d827b91b7dd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb-go/releases/download/v0.5.0-alpha.2/trbg_0.5.0-alpha.2_darwin_amd64.tar.gz"
      sha256 "1d4ae31364369eccefcd5162631564c34755d190d1766aa327221bb91eaf6ebe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb-go/releases/download/v0.5.0-alpha.2/trbg_0.5.0-alpha.2_linux_arm64.tar.gz"
      sha256 "33922482c06f12f3d0bfedc5dc0ea19f95483121f444b504fc886f58464984ff"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb-go/releases/download/v0.5.0-alpha.2/trbg_0.5.0-alpha.2_linux_amd64.tar.gz"
      sha256 "a73428ae2f9d58eb57b0fbd55b77324091e40fd6ee6dccc4e163f2c915be81cf"
    end
  end

  def install
    bin.install "trbg"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/trbg --version").strip

    (testpath/"trbconfig.jsonc").write <<~JSON
      {
        "name": "brew-smoke-test",
        "version": "0.1.0",
        "mode": "go",
        "sourceDir": "src",
        "outDir": "build",
        "packageManagement": "external",
        "go": {
          "module": "example.com/brew-smoke-test",
          "version": "1.27"
        }
      }
    JSON
    (testpath/"src").mkpath
    (testpath/"src/main.trb").write <<~TRB
      import trb/std/io

      def main()
        IO.puts("installed with Homebrew")
        return
      end
    TRB

    system bin/"trbg", "fmt", testpath/"src/main.trb"
    system bin/"trbg", "build", "--config", testpath/"trbconfig.jsonc"
    entries = Dir[testpath/"build/trb/entry/*/main.go"]
    assert_equal 1, entries.length
    sources = Dir[testpath/"build/trb/application/*.go"].map { |path| File.read(path) }.join("\n")
    assert_match "fmt.Println(\"installed with Homebrew\")", sources
  end
end
