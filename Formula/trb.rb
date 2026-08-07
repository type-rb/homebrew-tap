class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.8/trb_0.1.8_darwin_arm64.tar.gz"
      sha256 "33633e03acfd823c35750beeb165682f3d3134e1922d066b151b288224ef62a6"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.8/trb_0.1.8_darwin_amd64.tar.gz"
      sha256 "5e8f5a1b7b4fc06a4af25c819780ac0efc82cb80064980f9b3a8a88e1e43e1a5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.8/trb_0.1.8_linux_arm64.tar.gz"
      sha256 "3bbd1189c5c3ee115b5c8b575382329f77d9923e7c1cb1f99f932a49e0f0412d"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.8/trb_0.1.8_linux_amd64.tar.gz"
      sha256 "20e46d48c751f1e5b5c83151d88718764ed7153fbf02368517d185ceb164add7"
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
