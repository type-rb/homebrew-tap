class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.38/trb_0.3.38_darwin_arm64.tar.gz"
      sha256 "eaf417e8bfa27ac0dccd6eae14f411693bae8bb5b3f159975e97cfcdeddb846f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.38/trb_0.3.38_darwin_amd64.tar.gz"
      sha256 "cfb88b9b63c4f1ffa299147bb443ccd64654d94ec55d628cc5c60adea2894f20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.38/trb_0.3.38_linux_arm64.tar.gz"
      sha256 "447fd3feadc32f99264ae2dd987b75639fbc716ad0ef8afbcb65472d217f89ae"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.38/trb_0.3.38_linux_amd64.tar.gz"
      sha256 "733a27c8ca71246256b9f27324abb3b3c374f0739c8acc1bdace192759cc3558"
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
