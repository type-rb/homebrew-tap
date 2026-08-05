class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.3/trb_0.1.3_darwin_arm64.tar.gz"
      sha256 "b698b8f09525b95878f05db7d582a4a68ae2bc846f7a98a2b9e37417d09a5fb0"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.3/trb_0.1.3_darwin_amd64.tar.gz"
      sha256 "196ef8eda1d7ce481f0f29c27eebbf2b924e82146cfa7242f0a4b0611a4aa67b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.3/trb_0.1.3_linux_arm64.tar.gz"
      sha256 "151af76b5f66eda5c5a389c1e7a662e5ea6cf2759986a4d1db470b41d583f901"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.3/trb_0.1.3_linux_amd64.tar.gz"
      sha256 "43a00617e3e4f9eadc553d1adc9373c208e17499f1888544741196e206f9d0f9"
    end
  end

  def install
    bin.install "trb"
  end

  test do
    assert_match "trb #{version}", shell_output("#{bin}/trb version")

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
