class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.25/trb_0.2.25_darwin_arm64.tar.gz"
      sha256 "025ef10174595bc5ab32c1ad2cb27465fd8dcd51853459842c5988b2288c417c"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.25/trb_0.2.25_darwin_amd64.tar.gz"
      sha256 "afe1baf6cfb514d6995c55f05a2f9658aa1ddea6da8bde39e7c4744b23bcc1a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.25/trb_0.2.25_linux_arm64.tar.gz"
      sha256 "94b0e93764f7bb10d70c4c4c51ffaa3e6f0f69ca159e6b0f901934cf9f86e7ba"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.25/trb_0.2.25_linux_amd64.tar.gz"
      sha256 "a8f63170f5dca3a2c39bf7946254162b88547411fdd4256fda0d132136be4a6d"
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
