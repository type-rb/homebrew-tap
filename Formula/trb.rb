class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.30/trb_0.2.30_darwin_arm64.tar.gz"
      sha256 "7039756225387cb9464174c63f680f16250a9ee2c1d623512e828d9670f3480c"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.30/trb_0.2.30_darwin_amd64.tar.gz"
      sha256 "f2a9f33b9ea198b202d5447c8d9e6fb13fec305b7f9f3dc2f31de2960c157243"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.30/trb_0.2.30_linux_arm64.tar.gz"
      sha256 "6ca1fa2d1a2024d6e92d510e1df2620f6f883538906519dafdd892dbebe7bbc3"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.30/trb_0.2.30_linux_amd64.tar.gz"
      sha256 "5b701d2a26423825d780e27f599c2e3a4fb5c198b9ef5cc38a1d0eb6d16cf402"
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
