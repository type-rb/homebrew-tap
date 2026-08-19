class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.3/trb_0.3.3_darwin_arm64.tar.gz"
      sha256 "7aec8cbced52814b23432e87cc7c25a7081069c153ff778cd8573c8d94bb827d"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.3/trb_0.3.3_darwin_amd64.tar.gz"
      sha256 "5a6ad8f309833a67028058ec1c4fa4e39703d8f51225ee60d1c9e6cea3189cdc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.3/trb_0.3.3_linux_arm64.tar.gz"
      sha256 "2f68b3260645a8d5e3c21b0164d0110f63bd76d91ae7dfd9f7278b747f21698f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.3/trb_0.3.3_linux_amd64.tar.gz"
      sha256 "a34fd69b1a16c2d40ded1e2778a11ae61003389b4fc8145323b50c0aa87f3961"
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
