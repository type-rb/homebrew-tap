class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.4/trb_0.2.4_darwin_arm64.tar.gz"
      sha256 "a5e5c7a5d7d5787e61738c7325ca0a862c12b7b40195d8fbeba45948494415e1"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.4/trb_0.2.4_darwin_amd64.tar.gz"
      sha256 "2ba6e93e09309413c6ca66733220abc19940b6ec2d9dd48687cb9c50a40b6b2a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.4/trb_0.2.4_linux_arm64.tar.gz"
      sha256 "814d3781eeaf814bd209f5e8ce010a7ddfd1a65b51bb838f1d2e6597eee1aa71"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.4/trb_0.2.4_linux_amd64.tar.gz"
      sha256 "b7e908c91a82e2112720785db468124a4007491a0b78fa8ee0e5e6baed87c612"
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
