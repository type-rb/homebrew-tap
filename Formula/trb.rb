class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.21/trb_0.2.21_darwin_arm64.tar.gz"
      sha256 "d02a7b60e0fe639fefcef6a481a21e2eed0173713b922cf5f349905379f230ee"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.21/trb_0.2.21_darwin_amd64.tar.gz"
      sha256 "ff11e700e8bfcea28b752bd4461731dbee454fba736b873c09ee75f7b1dd2ae0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.21/trb_0.2.21_linux_arm64.tar.gz"
      sha256 "9fd77204b3e43fb304f329665f6ad1d60b5b7ac12a463ca65426507500c6eed7"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.21/trb_0.2.21_linux_amd64.tar.gz"
      sha256 "6abd70ab930356e33aa1e9fef940569c231456265320eacabc987051a9419570"
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
