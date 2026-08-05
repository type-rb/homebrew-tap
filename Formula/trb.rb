class Trb < Formula
  desc "Ruby-shaped typed language that targets Ruby, Go, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.0/trb_0.1.0_darwin_arm64.tar.gz"
      sha256 "6a9dc56f68c306aeb80b80885da5362b155ac74577667175097880172d96dacb"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.0/trb_0.1.0_darwin_amd64.tar.gz"
      sha256 "e793119e00f9e8c71a219594ab1f1102b7034d58555da76313ee070fd8bc68e9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.0/trb_0.1.0_linux_arm64.tar.gz"
      sha256 "f74a2ce221d44fd1509787aa7633d69624a697614678b39f144443b70399af5e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.0/trb_0.1.0_linux_amd64.tar.gz"
      sha256 "86e0d1b2001a355c5b1ef3dca3c4376bb21b5629eafc613ee2a84c555838eaab"
    end
  end

  def install
    bin.install "trb"
  end

  test do
    assert_match "trb #{version}", shell_output("#{bin}/trb version")

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
