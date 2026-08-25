class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.34/trb_0.3.34_darwin_arm64.tar.gz"
      sha256 "6a3f1b35d14d685f69272b4a1b118fe1b851f4bebabc8d7f464932bbfd9f1511"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.34/trb_0.3.34_darwin_amd64.tar.gz"
      sha256 "785a60ab0e1b4a4dba026f82d7a024f724bf7382bb2531b3313dbdc786335929"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.34/trb_0.3.34_linux_arm64.tar.gz"
      sha256 "0cb98d902886003c5b14ad8d8a050a8f36def6b4d68d1c9b6178de8d5e3fa2db"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.34/trb_0.3.34_linux_amd64.tar.gz"
      sha256 "addba6e317970bdfcd2dfb31c15b2772cb267aa6810ecd866654df357d0ee4e2"
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
