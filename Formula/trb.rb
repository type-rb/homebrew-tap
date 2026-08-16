class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.24/trb_0.2.24_darwin_arm64.tar.gz"
      sha256 "bc09b02715da83ab38932abda4367a8e0bf04a87e0a5c982e8c432b42b57a7fd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.24/trb_0.2.24_darwin_amd64.tar.gz"
      sha256 "9cf998868d288ac0cc9d34c1ecb715747aeb57e4e123e5b2e95c481beab06fe7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.24/trb_0.2.24_linux_arm64.tar.gz"
      sha256 "887f976f821e920bb8df9feab50af69e1983f5197aa02a8d99e980c2bfc1f659"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.24/trb_0.2.24_linux_amd64.tar.gz"
      sha256 "4983fd26b7423a0574303623c5e0e2c72f79756b1a8adb7040dd02e93ce7fab6"
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
