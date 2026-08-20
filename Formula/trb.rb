class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.5/trb_0.3.5_darwin_arm64.tar.gz"
      sha256 "4d97f1780107c5e69d7d3b81cff2aa17429272a1400597d304222cda96a3981a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.5/trb_0.3.5_darwin_amd64.tar.gz"
      sha256 "991572dcdd9621c9df39d0adc302bdfa6318b617a0166bebeed95a47c2406734"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.5/trb_0.3.5_linux_arm64.tar.gz"
      sha256 "41cea1230861f8dfb846a8eaed1167714ffc8c4d0875fa9510020f1438610bc8"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.5/trb_0.3.5_linux_amd64.tar.gz"
      sha256 "79e4431b4fe332eb2023242c1f9e3b684059ef5734d28a35c3b8f86048369be1"
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
