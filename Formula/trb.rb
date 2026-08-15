class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.12/trb_0.2.12_darwin_arm64.tar.gz"
      sha256 "7dc135660e468936c194a7cdf8b7043ce72271f62d159f1b800090091044d7c7"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.12/trb_0.2.12_darwin_amd64.tar.gz"
      sha256 "146d420b59f1edac6eee5314a636cba5fcae13ca72783b73a8c507518f7e85dc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.12/trb_0.2.12_linux_arm64.tar.gz"
      sha256 "8ce77eccc0c53d57e37f4d8f8bf805081e7ddf0520c7a193a373a536d32adf2f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.12/trb_0.2.12_linux_amd64.tar.gz"
      sha256 "ab927c9e9d505320988eb9bfaa13580df7050f0c6afdc342cb32ec642a493b74"
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
