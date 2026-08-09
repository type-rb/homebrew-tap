class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.12/trb_0.1.12_darwin_arm64.tar.gz"
      sha256 "e3a7d26e1179d1a9540ba237526cdd37bf0b66d3f8c2b2ff764c54ec539911ed"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.12/trb_0.1.12_darwin_amd64.tar.gz"
      sha256 "0290827e28e7ec6690af16adfa39d7ad962dd3c7e2e3d670ff7c20085b82728f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.12/trb_0.1.12_linux_arm64.tar.gz"
      sha256 "4a4fefce68ab7c79f6ea4c90f667191f33b78f3ee90d6572cda3e00463bbe72e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.12/trb_0.1.12_linux_amd64.tar.gz"
      sha256 "dcf8e44a87a80ca71ce3bd575ff2aefaeb26dc179c3f781b2c4c3686d51d4e8d"
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
