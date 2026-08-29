class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.0/trb_0.4.0_darwin_arm64.tar.gz"
      sha256 "78b99068fb7683c9c1198c86370c473e2534d25733dc07f9c93fb0dd1ce88298"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.0/trb_0.4.0_darwin_amd64.tar.gz"
      sha256 "ddcdb850bd7781ab631a80524893cd94b218b42038412ce3c5921204a2176e33"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.0/trb_0.4.0_linux_arm64.tar.gz"
      sha256 "d65ac3260bd081b830bf7327f940b679fe42b542967325468f7cfebdc94ee33b"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.0/trb_0.4.0_linux_amd64.tar.gz"
      sha256 "1a5df9bf525aa558fbf58979bdaf7958f9cf306010b15c97e9a7d36a04adb8a7"
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
          "version": "1.27",
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
