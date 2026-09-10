class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.6/trb_0.4.6_darwin_arm64.tar.gz"
      sha256 "7597f9c895d01dd501fe44c53938ffe532800a70c61a3f98eaf1e411de4e3dcb"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.6/trb_0.4.6_darwin_amd64.tar.gz"
      sha256 "f01f8dd3bfe55c7389b72065195e8029b73ba16200c273b3953eb37d4bc361e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.6/trb_0.4.6_linux_arm64.tar.gz"
      sha256 "720e22faacf6ff15be45cc7bfe789499d6373e98ebba4daf0fdc9270aaaaebd8"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.6/trb_0.4.6_linux_amd64.tar.gz"
      sha256 "2d6c35c6ed6cbaf30eb8bd0c5646c90add2c134037b767efa6cab0b00451d0f9"
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
        IO.puts("installed with Homebrew")
        return
      end
    TRB

    system bin/"trb", "fmt", testpath/"src/main.trb"
    system bin/"trb", "build", "--config", testpath/"trbconfig.jsonc"
    assert_path_exists testpath/"build/main.go"
    assert_match "fmt.Println(\"installed with Homebrew\")", (testpath/"build/main.go").read
  end
end
