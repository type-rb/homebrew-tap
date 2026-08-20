class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.4/trb_0.3.4_darwin_arm64.tar.gz"
      sha256 "eac2b9577976a4e0c0fd7d7e596b68c80087355da72d500593d3f71b822e70fd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.4/trb_0.3.4_darwin_amd64.tar.gz"
      sha256 "9ec85b0ae80fe7be25893ad8647b89605e7caea86e90513ce002e212d1025484"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.4/trb_0.3.4_linux_arm64.tar.gz"
      sha256 "34d69ec6962f2de2753eaf397b23e2a0e8a753f571f5ba974fc431207e2605d9"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.4/trb_0.3.4_linux_amd64.tar.gz"
      sha256 "168fd19ff3c27c2da0b31eff9c15a252e745f849c49647cbc39fab0de2dee8c2"
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
