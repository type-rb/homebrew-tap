class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.11/trb_0.4.11_darwin_arm64.tar.gz"
      sha256 "a362d5d04c4cd61880e04f5b76941a18febd66ec4a3ad84ba581e9b4d9aa7d4a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.11/trb_0.4.11_darwin_amd64.tar.gz"
      sha256 "35e1744420d21b494936c984d7125a8f305edac0712d997f565bb849c9f026e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.11/trb_0.4.11_linux_arm64.tar.gz"
      sha256 "2a7542a015594f3580860c93a0d5aab1669e4af6937fb7a5bc870cae8876d49b"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.11/trb_0.4.11_linux_amd64.tar.gz"
      sha256 "c2b98ea983fd6f1867a81e22ed887af52e43ead82fa38f4d83117d90f00d731e"
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
          "version": "1.27"
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
    entries = Dir[testpath/"build/trb/entry/*/main.go"]
    assert_equal 1, entries.length
    sources = Dir[testpath/"build/trb/application/*.go"].map { |path| File.read(path) }.join("\n")
    assert_match "fmt.Println(\"installed with Homebrew\")", sources
  end
end
