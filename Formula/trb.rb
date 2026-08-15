class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.20/trb_0.2.20_darwin_arm64.tar.gz"
      sha256 "c06c03f6eb44a30cf2b8fb7132530f01fff240a5f8771bc47fec5601d6fe95ef"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.20/trb_0.2.20_darwin_amd64.tar.gz"
      sha256 "58a95ea14babbcdd8e9e13bd4e5bcf48ff5d0f1287349109a064468d1bb096e4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.20/trb_0.2.20_linux_arm64.tar.gz"
      sha256 "edac1ed43fb739b13f4560c667892a56afee93db1c81b9d5664137dfe3ce6d6e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.20/trb_0.2.20_linux_amd64.tar.gz"
      sha256 "759cd2f894977de4995fdc6d003d8530124c17174f20817538f87cdc8fe108e5"
    end
  end

  def install
    bin.install "trb"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/trb version").strip

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
          "version": "1.26",
          "rootPackage": "main"
        }
      }
    JSON
    (testpath/"src").mkpath
    (testpath/"src/main.trb").write <<~TRB
      import trb/std/io

      def main()
        io.puts("installed with Homebrew")
        return
      end
    TRB

    system bin/"trb", "fmt", testpath/"src/main.trb"
    system bin/"trb", "build", "--config", testpath/"trbconfig.jsonc"
    assert_path_exists testpath/"build/main.go"
    assert_match "fmt.Println(\"installed with Homebrew\")", (testpath/"build/main.go").read
  end
end
