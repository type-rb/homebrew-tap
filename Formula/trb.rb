class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.1/trb_0.3.1_darwin_arm64.tar.gz"
      sha256 "0fa8d7cc5812ba36b7131df6dbcd9ebe2f30f96647e79f98afbedab1ea9c0278"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.1/trb_0.3.1_darwin_amd64.tar.gz"
      sha256 "595bd94d45242632177e484ba827664d746f7e6c9bbe328742b041e23b41c137"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.1/trb_0.3.1_linux_arm64.tar.gz"
      sha256 "2d7185eeab891af0cce081c0285c9b03abb80bc934593c8258fc2d23cf6b473a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.1/trb_0.3.1_linux_amd64.tar.gz"
      sha256 "10bf29fa26a2ec7e8601feb85fdc584ba30f80cd6ad032d4bc74b4536edaedd7"
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
