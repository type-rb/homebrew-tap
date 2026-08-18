class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.31/trb_0.2.31_darwin_arm64.tar.gz"
      sha256 "cfe1ac33e3af27a4074d4e957b055f2799b9682e1f14d1f4dfecfc18ccc9b4c0"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.31/trb_0.2.31_darwin_amd64.tar.gz"
      sha256 "2fe22bd182782ae6ff2ede928a85f07f2e0c14308552703b5054f628710244d3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.31/trb_0.2.31_linux_arm64.tar.gz"
      sha256 "d580eae0f6334bdc6ccdfd1aac9af4370ea514f867f7b417b3b12c3705e40778"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.31/trb_0.2.31_linux_amd64.tar.gz"
      sha256 "6147167235bbfdb91a45e3dd01f003ee4c599a10aeebbdec7ad4f7e2cb2921e8"
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
