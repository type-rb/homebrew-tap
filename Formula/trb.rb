class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.20/trb_0.3.20_darwin_arm64.tar.gz"
      sha256 "4c8a6c04fdabee7436351c8360590f76340d230ce94dde4b4be645e3866b94dd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.20/trb_0.3.20_darwin_amd64.tar.gz"
      sha256 "b74221cbbc50fc7940ea6428d8e9514145d77f3acf73712f71d28e24b9f0512d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.20/trb_0.3.20_linux_arm64.tar.gz"
      sha256 "49b2daa46a5520a6e6057b6d131a29535b7bbcf1ea40d3c23dd65e60fd00cc2d"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.20/trb_0.3.20_linux_amd64.tar.gz"
      sha256 "48545be8670cd6685a9ec0e08b9b9915a8b10e670042bd357011a4083adb5352"
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
