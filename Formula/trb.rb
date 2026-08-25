class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.31/trb_0.3.31_darwin_arm64.tar.gz"
      sha256 "dee161bde3a30deec24da38fbf466ffca247182755ba56f6c7885105b071e31b"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.31/trb_0.3.31_darwin_amd64.tar.gz"
      sha256 "faf6eda05d26b855d0e807599365a86537fc6725651b38d4b235f146f9e4e124"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.31/trb_0.3.31_linux_arm64.tar.gz"
      sha256 "a310a4f79aa5808b9478b8745ba4106fc9def9f325544a646c0ed363688f69f9"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.31/trb_0.3.31_linux_amd64.tar.gz"
      sha256 "39c7fde4fa19665c6a5bb4ab402385a62c926da42e0789e269a5cf3f1938abce"
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
