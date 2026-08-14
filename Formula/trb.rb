class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.8/trb_0.2.8_darwin_arm64.tar.gz"
      sha256 "99555fa18a5c10b0d87d87c80660e1668856caeac60b5d59a73312057ec7ff15"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.8/trb_0.2.8_darwin_amd64.tar.gz"
      sha256 "35ab121ea7925820c185f8b8031e29cb1e3169b604681ba7207237b6d003d16e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.8/trb_0.2.8_linux_arm64.tar.gz"
      sha256 "483e8aebd588fa1fc9c1102f087e4750e5bb02c890eb0d568709b1191baeec8f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.8/trb_0.2.8_linux_amd64.tar.gz"
      sha256 "6956c2bddcfd269fc123abc423f8e94348476af34ca3f4f559f0dcaae72b6bf7"
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
