class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.6/trb_0.3.6_darwin_arm64.tar.gz"
      sha256 "0b78e7d50f7a118a1911f5f352fc744aaa7f52e2d203475703e02f4c95184de1"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.6/trb_0.3.6_darwin_amd64.tar.gz"
      sha256 "e9956054399d31b48ed589d38d528b9469c1a12324ad234913e89db0148089a0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.6/trb_0.3.6_linux_arm64.tar.gz"
      sha256 "382b871f686508c41c69a909663d3cbe60b0f0d8b19bf72ec04c0c0743f66bbc"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.6/trb_0.3.6_linux_amd64.tar.gz"
      sha256 "a261ae4f0cf6d0d6ac7546350b90e68a4b839bba7ca822e4e29d18c0d5423cbe"
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
