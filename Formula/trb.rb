class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.27/trb_0.2.27_darwin_arm64.tar.gz"
      sha256 "06dfa51d5d883e639f615c8fcf721b8b0014a519d3b7cbc0bc9e05d8c34ad828"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.27/trb_0.2.27_darwin_amd64.tar.gz"
      sha256 "f884d2a1b68e1379a3cc766510bd81ec5a2ee42b3deb10635fc06f38d5bdebf0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.27/trb_0.2.27_linux_arm64.tar.gz"
      sha256 "69e474da431b162802a5dff57c07a1a7cf2be8b6449cdad37538a875e8d478f2"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.27/trb_0.2.27_linux_amd64.tar.gz"
      sha256 "8c9543c9ed923a0b8837d733ecb6e674611f2ea7e411a5c18e7e1f70a8d5ff84"
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
