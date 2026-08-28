class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.44/trb_0.3.44_darwin_arm64.tar.gz"
      sha256 "c711356ceed518a9ab78a4236f8eed4a6ddf038892bb15ab1a2a9e40de00202f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.44/trb_0.3.44_darwin_amd64.tar.gz"
      sha256 "4d197bb7719737879cbac53d603d05fbf76f46dd27d5acc1695171f7c5f6fca6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.44/trb_0.3.44_linux_arm64.tar.gz"
      sha256 "57dc5f977a07b2c0bf50aa777a58c31f24147e10490d1964a8609d501b6b212f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.44/trb_0.3.44_linux_amd64.tar.gz"
      sha256 "73a4f4bc2f4f3730ded634e7a3cbd883399bb38c92e380b3e0d68762b79f15d7"
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
