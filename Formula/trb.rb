class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.15/trb_0.3.15_darwin_arm64.tar.gz"
      sha256 "95990b9007b999efc0fd6327dbd6a434d3005002277a217f28c8d793f17ecdab"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.15/trb_0.3.15_darwin_amd64.tar.gz"
      sha256 "6b0a88ad6245c73774d8d770d83e96ce9e849bd8c8d018bfacfaf1ba365fcdd6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.15/trb_0.3.15_linux_arm64.tar.gz"
      sha256 "654e7c9e3580be8c974eb7fe58e49a6fafc43fda94005f25b5e953aa1c214465"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.15/trb_0.3.15_linux_amd64.tar.gz"
      sha256 "20fc9da137769539dc592d2f094023473d5ab3f069cb342008dab8cd396785a1"
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
