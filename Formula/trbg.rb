class Trbg < Formula
  desc "Go implementation of TypeRB"
  homepage "https://github.com/type-rb/type-rb-go"
  version "0.5.0-alpha.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb-go/releases/download/v0.5.0-alpha.1/trbg_0.5.0-alpha.1_darwin_arm64.tar.gz"
      sha256 "a1cf8cda1750ade369a4ec62328d4eb5dbc6a10ffdc4e379287ad7d4bed366e5"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb-go/releases/download/v0.5.0-alpha.1/trbg_0.5.0-alpha.1_darwin_amd64.tar.gz"
      sha256 "1de6cc557003066af02d42d36b70bba24152e640ef245c4b51f2e7eeaf607cb0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb-go/releases/download/v0.5.0-alpha.1/trbg_0.5.0-alpha.1_linux_arm64.tar.gz"
      sha256 "df9bcfba5fb0c14eda1f8ed547dab5a8604b2755dce0cdda627d35921a3d5c07"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb-go/releases/download/v0.5.0-alpha.1/trbg_0.5.0-alpha.1_linux_amd64.tar.gz"
      sha256 "4d7e86f5323c7cf6330bf36709698de730459533852b6c7111d53253027ad546"
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
