class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.47/trb_0.3.47_darwin_arm64.tar.gz"
      sha256 "79de7d4baca8a29cfb3638037d9434bd29f4051700a702cfcf0b70b9b54c653f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.47/trb_0.3.47_darwin_amd64.tar.gz"
      sha256 "847d0677d4c67157f3d2d28d71eaddc54baaf05d624ec1a32d5ead054a69f8bd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.47/trb_0.3.47_linux_arm64.tar.gz"
      sha256 "211a8f756a18e2a4376d3fc2030ed1003a34180b14d4cdd5b1b912f91781ecff"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.47/trb_0.3.47_linux_amd64.tar.gz"
      sha256 "9aa1d755816751f6d7b4ed2e9e2cd6f75ab5822df43359c6bd6dcc59f4a1f9b3"
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
          "version": "1.27",
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
