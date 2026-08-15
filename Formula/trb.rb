class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.9/trb_0.2.9_darwin_arm64.tar.gz"
      sha256 "47d5cc93e7be2d84d52c2ac12d98b4da5e9bc694faa42b48a9e8586a9b1137c5"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.9/trb_0.2.9_darwin_amd64.tar.gz"
      sha256 "13dc9af6e0fb9248d313ced172b8f7d5b15fbe060e365f3c13df244a8687f285"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.9/trb_0.2.9_linux_arm64.tar.gz"
      sha256 "3b3e2bede61c91221862242ca7dcedd8e724def6c3e8f5153395204449104229"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.9/trb_0.2.9_linux_amd64.tar.gz"
      sha256 "05c6937cb1676ef231e2e2442bcc266528e37c598217c10730d749c9779aeedc"
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
