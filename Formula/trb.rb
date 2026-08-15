class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.11/trb_0.2.11_darwin_arm64.tar.gz"
      sha256 "4e406d96b7cad0519e20b96fa50c35960b497bdfe017b69f830756bfeae8a766"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.11/trb_0.2.11_darwin_amd64.tar.gz"
      sha256 "25fd7d8da661666de8415fcb52213de6e1fe61874036544ada27c53db4ebc92d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.11/trb_0.2.11_linux_arm64.tar.gz"
      sha256 "9e5ebed7d2dc618e4249ddc85bfc2c8aabc7fce15125d1983681c47ecec136d3"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.11/trb_0.2.11_linux_amd64.tar.gz"
      sha256 "e78085fde4d28fa1c63a5fc709e4e2247f5b0a7227eea2526719c1fa56e277e3"
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
