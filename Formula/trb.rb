class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.16/trb_0.3.16_darwin_arm64.tar.gz"
      sha256 "4aa2fcd1cf8574dd1e75a570fcc950932bb8a0177aa3846245e849c2b956af62"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.16/trb_0.3.16_darwin_amd64.tar.gz"
      sha256 "f1a0acc98a5bfb583412751f5913b31f6d31a6987bd1251a07bda4d0ca3ce581"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.16/trb_0.3.16_linux_arm64.tar.gz"
      sha256 "45bc6908683ff9a1c584da4abf075880741dd67dd44e6fa70b3c9eade5cc65a8"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.16/trb_0.3.16_linux_amd64.tar.gz"
      sha256 "bfed8f19f898ac4e461ce20d9f4d70ce45a0004f926f6023b4403e458287eedf"
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
