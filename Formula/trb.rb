class Trb < Formula
  desc "Ruby-shaped typed language that targets Ruby, Go, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.1/trb_0.1.1_darwin_arm64.tar.gz"
      sha256 "05d1df1f18f1e996ae688ccca4594c1fab861ec67b6a1d9bc20572edf284566c"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.1/trb_0.1.1_darwin_amd64.tar.gz"
      sha256 "d86a2f2bd9b66a66a653b0e5944d68e7057a6869bed1341b8f63cfc98dcaff9d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.1/trb_0.1.1_linux_arm64.tar.gz"
      sha256 "f1dcff9f73e0a0684dfa1ee6261838970fab19bcbb395d67ab0df55ba1db369b"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.1/trb_0.1.1_linux_amd64.tar.gz"
      sha256 "062dccdf37e3fb9e6358d269dd54bc04dafa617dd033fbe533d203230e81cd0c"
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
