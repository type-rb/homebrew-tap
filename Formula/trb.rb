class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.7/trb_0.2.7_darwin_arm64.tar.gz"
      sha256 "fe3aa3efbfdfc92472dc98e5304977a92b53f8e55b4fa8524e4d64b0de80b16d"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.7/trb_0.2.7_darwin_amd64.tar.gz"
      sha256 "5c52eb4a1f49fddb661d55b094b049b40f45d1578d389c7bdf74a766d071134b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.7/trb_0.2.7_linux_arm64.tar.gz"
      sha256 "76ce7556cc69f1496317afef2bcc9af85c68c566850aaa970172dd0dda0e92a6"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.7/trb_0.2.7_linux_amd64.tar.gz"
      sha256 "e638bab1252fef273fd59db92485e7f7da60e90f3c9da940af76c85a505252a2"
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
