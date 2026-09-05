class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.4/trb_0.4.4_darwin_arm64.tar.gz"
      sha256 "de5f4ba33143e653f7962149a9d0b49fcbf737989925e94aeb460cad2b89343f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.4/trb_0.4.4_darwin_amd64.tar.gz"
      sha256 "2ed5c0835ce9e7374eaa7f3dd076e7d9b8f449fd62ac982e0e8343cd7ac6ee79"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.4/trb_0.4.4_linux_arm64.tar.gz"
      sha256 "48ce2b222e4e282c642d62fef36721838ea74cc0e9c2d4f11a77c96bfb1b09fd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.4/trb_0.4.4_linux_amd64.tar.gz"
      sha256 "afac508f18e1457df214c35f37acf898682fcf434e4d21d050574559b6162b59"
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
