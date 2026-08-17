class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.29/trb_0.2.29_darwin_arm64.tar.gz"
      sha256 "6b7fb869c113e7c9632ccb21d3abadd3f2ec63dd8c1a585122849d2e69c2bfd0"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.29/trb_0.2.29_darwin_amd64.tar.gz"
      sha256 "bcaab800c11b7878539c84d320224c5e122805b2885c672f84c8efa88547fc81"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.29/trb_0.2.29_linux_arm64.tar.gz"
      sha256 "960e3775357f06440d66564f9d4f23198d30a30adbbbddf3aadafc00d9f5a76e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.29/trb_0.2.29_linux_amd64.tar.gz"
      sha256 "fd66436d2c7e524715287f1cca2351b4af842dbf24a97fd2828e8a11b6fee9f8"
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
