class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.3/trb_0.2.3_darwin_arm64.tar.gz"
      sha256 "98192befff2b749955e0069532dd6ad7d31cc8b85a9d417619461b7fc5a3cadd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.3/trb_0.2.3_darwin_amd64.tar.gz"
      sha256 "b64a0d75d04050bf4d0061c8cbdd423631df603bdc78f397ad54488b16a6f514"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.3/trb_0.2.3_linux_arm64.tar.gz"
      sha256 "1f13ad9b072352dde9586ff2e9cc461a7fcd922a8fbe0fd43b2f76b83420f21e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.3/trb_0.2.3_linux_amd64.tar.gz"
      sha256 "f097503ea390b5c274e2012a9c634cd89b0607cd256679b5b004d977bb249e75"
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
