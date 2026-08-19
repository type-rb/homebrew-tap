class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.2/trb_0.3.2_darwin_arm64.tar.gz"
      sha256 "2614541f0cabd17ccad0a10615e87cc680da6bbe0b6943c14cf2d5bc372ce1a3"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.2/trb_0.3.2_darwin_amd64.tar.gz"
      sha256 "8a7750efea061bf72b3ec686252d1e8dd4eeb65d39dd7daa77654ec1f0f6f44e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.2/trb_0.3.2_linux_arm64.tar.gz"
      sha256 "a7e186d40b2a4a992549b322b3bc1aeec8f81be4458895905fdb5b961926f827"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.2/trb_0.3.2_linux_amd64.tar.gz"
      sha256 "8dcb3c0d7f2687f95cc690b7aaf05923d6560e6d1c947555c05b2e855c8fb4d2"
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
