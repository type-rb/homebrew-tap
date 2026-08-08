class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.10/trb_0.1.10_darwin_arm64.tar.gz"
      sha256 "d09b8324e15f3d3861d6b958d7d891bd1edf4218a9fa83621891c994ba8460bb"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.10/trb_0.1.10_darwin_amd64.tar.gz"
      sha256 "8b0709aae69272cd3cf2a53fe78a1f23d85ab6d33486c35f19a0ffdd5eb9cd8c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.10/trb_0.1.10_linux_arm64.tar.gz"
      sha256 "6afb6a22c727d6aaf7d3c0c610cd149e6c49e3b9590d817d5d82695e085a5fa8"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.10/trb_0.1.10_linux_amd64.tar.gz"
      sha256 "38204cfa5f4a9ec5ef46ffd855e678c20d1934cd181917c05bd48f91a6c25f2c"
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
