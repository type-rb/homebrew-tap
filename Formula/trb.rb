class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.12/trb_0.3.12_darwin_arm64.tar.gz"
      sha256 "906086685143bed2e8672b101a5b4dabf4a0434e587be5d6155b6afc665917c8"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.12/trb_0.3.12_darwin_amd64.tar.gz"
      sha256 "12eefe650d4442d1c0c0df6e8b7a4d3cb21e24e208475822f3cf0b261539e877"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.12/trb_0.3.12_linux_arm64.tar.gz"
      sha256 "55e0cb4c056dee3d64cc53015f55928e793cd86c7ffbbd63a948c574df351896"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.12/trb_0.3.12_linux_amd64.tar.gz"
      sha256 "f0d947d679823168b0adb47c0a8ccde11f5ff6da102f1ca2c9b5fcf7ba6efb0a"
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
          "version": "1.27",
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
