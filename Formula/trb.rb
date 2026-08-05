class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.2/trb_0.1.2_darwin_arm64.tar.gz"
      sha256 "7d7d9c94e6a1b3a82adb06ec6b87b0c07fcd6028db73a35d9476378c825830b6"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.2/trb_0.1.2_darwin_amd64.tar.gz"
      sha256 "82bf22c2219be267150a19fbbe42ca9d0f992f139b3b0feb0179384490c61a87"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.2/trb_0.1.2_linux_arm64.tar.gz"
      sha256 "e0d51b71fda305778b8c85ed1a0a58b915f2fee1d654d391fc09e1f0a48bc081"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.2/trb_0.1.2_linux_amd64.tar.gz"
      sha256 "14b99065cfcd98bd41b2e7a84b14766be55eda43dbd161bc2e9b6b3ce50b0c44"
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
