class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.18/trb_0.2.18_darwin_arm64.tar.gz"
      sha256 "66bc48af5db34953cb79cf2c008bc4ae82da6af2f7324dcdcbd9590984525975"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.18/trb_0.2.18_darwin_amd64.tar.gz"
      sha256 "7b36edd90a0ba2e59e580e86486a0dc93df7ee331fbb69a9ffcf2056390b9f92"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.18/trb_0.2.18_linux_arm64.tar.gz"
      sha256 "e62db6fc4833d7dd739094a1c45ec7cfeefa3c6a7f9ec03a5998059a680371a0"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.18/trb_0.2.18_linux_amd64.tar.gz"
      sha256 "72bf9a5e76c86081013f8281182436f2b103612df4d93d261e82c963f0618077"
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
