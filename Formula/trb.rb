class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.2/trb_0.2.2_darwin_arm64.tar.gz"
      sha256 "eb1b4f2315a05ddf66bbfd7f83799f3b67fadce0c645d382a9dd65f55f9ae11f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.2/trb_0.2.2_darwin_amd64.tar.gz"
      sha256 "1c25b4840612bb40dfe1fe495603dd7070ccd4865a23bd811bf00482c9416006"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.2/trb_0.2.2_linux_arm64.tar.gz"
      sha256 "9ed447570846af672fb1775575c95a05f8d6dec247b129a65c72757890b4d26d"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.2/trb_0.2.2_linux_amd64.tar.gz"
      sha256 "64e0e38c69701aa864abaf56d66fc492de802b78b96637d1813637c9c6ad7084"
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
