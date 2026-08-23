class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.22/trb_0.3.22_darwin_arm64.tar.gz"
      sha256 "e95666070c409b8524925134207640489b11f2fb6ca98ce0af24f1afee075428"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.22/trb_0.3.22_darwin_amd64.tar.gz"
      sha256 "094cef3ba1b087e913754edde3f178ce1e054b1743f34eba3eba3297864ebe91"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.22/trb_0.3.22_linux_arm64.tar.gz"
      sha256 "d79fcbe4d62796a48e492f0c29439bba1557bb6c445f4457de19a9a448082ca9"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.22/trb_0.3.22_linux_amd64.tar.gz"
      sha256 "2b345d13fb0b488dbcf1de00427ed56a0436b2aeb9288b0a160af3ada212cead"
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
