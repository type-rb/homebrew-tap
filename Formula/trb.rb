class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.5/trb_0.2.5_darwin_arm64.tar.gz"
      sha256 "2de6cf7235ae7e9f37488f987ab0ade11a9a2be130522d424086facb826486e8"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.5/trb_0.2.5_darwin_amd64.tar.gz"
      sha256 "3e3ff00b28cfd3571f852f752f774a7fb8a220f58e8d226ee5a2b6f630c1e035"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.5/trb_0.2.5_linux_arm64.tar.gz"
      sha256 "7319073e05b945724088462d9299f09cb2a84287abb7059583bf364f507ca0be"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.5/trb_0.2.5_linux_amd64.tar.gz"
      sha256 "17d166d2998388eed6fe9486a768b7e1f54845aec28b696d0e9b90fc2373a1c4"
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
