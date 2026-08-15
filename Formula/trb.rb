class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.10/trb_0.2.10_darwin_arm64.tar.gz"
      sha256 "4f014daab7c5fd4a237951086c74984b5c674534d361ffbe4736a484efe1f83d"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.10/trb_0.2.10_darwin_amd64.tar.gz"
      sha256 "1163fa2927622f627883fde55b0f50588ee139c529d10a88147e87dad4110130"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.10/trb_0.2.10_linux_arm64.tar.gz"
      sha256 "adb5b29f02374c2c0c8df9f8598d355337064cb580d365265553505890d06c5a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.10/trb_0.2.10_linux_amd64.tar.gz"
      sha256 "ee6297c87f1fbd1904ce88ef68510a4766cb5a87107f2ced05c2b1dc8587114f"
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
