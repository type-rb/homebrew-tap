class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.0/trb_0.3.0_darwin_arm64.tar.gz"
      sha256 "3312330844cd2b4af5d1b8ffdd1f8ca9f4daae24ccba5b88897070bc66ba4376"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.0/trb_0.3.0_darwin_amd64.tar.gz"
      sha256 "2f625d9e0920cf08a1d601348fefe0f88a70b505f9e26eb4bc217551574461a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.0/trb_0.3.0_linux_arm64.tar.gz"
      sha256 "2bc7355b137571693556ebb02fa249ac49fa79cbe74db927b84a9f5afe4e8bbd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.0/trb_0.3.0_linux_amd64.tar.gz"
      sha256 "8c35883b7ee2551fcee7063f05656d1c469ff8ee7e15ef3eb0ba171dc5e2faae"
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
