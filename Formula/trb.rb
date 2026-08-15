class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.14/trb_0.2.14_darwin_arm64.tar.gz"
      sha256 "54adfc90fcc1cbf6808945ed0a3484c5f5d9a811de0eee6151442afc76305f1a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.14/trb_0.2.14_darwin_amd64.tar.gz"
      sha256 "29eac9ca12c7ea7f914511518bb4f955d4a8908c242e7c09373fdef14f971255"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.14/trb_0.2.14_linux_arm64.tar.gz"
      sha256 "1e56f2318c4fd6993bdd04453cbe574b22239840a446e4cf19d8f4563017006f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.14/trb_0.2.14_linux_amd64.tar.gz"
      sha256 "ff39d5f63d83f8fa0f75bb79fb5f2b90f40cd90b867d9679a050006c44bc3aa2"
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
