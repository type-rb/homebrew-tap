class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.14/trb_0.3.14_darwin_arm64.tar.gz"
      sha256 "1e325ce9927b060280673591898b38a1a7ae07c24f2e3043ed0edff46303032c"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.14/trb_0.3.14_darwin_amd64.tar.gz"
      sha256 "a1df315a83d463204f6779cf3587ffad7f3106b2b8be11c91941faede3b02123"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.14/trb_0.3.14_linux_arm64.tar.gz"
      sha256 "e906c694bff3ddc4d246e95983a87df86c5b0e5e9119af717949bb3fd375f51c"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.14/trb_0.3.14_linux_amd64.tar.gz"
      sha256 "375052b4e01cc400f670200eb8b3f5a2809dbfc7d8134e572f528a8a3406cbe3"
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
