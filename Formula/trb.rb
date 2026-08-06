class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.7/trb_0.1.7_darwin_arm64.tar.gz"
      sha256 "68380a2cd3660d3e860f1cb3fc41969065b88c0273e5b14a09ea3f93608c775b"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.7/trb_0.1.7_darwin_amd64.tar.gz"
      sha256 "b7f15e6fb1bf20529e307f20d18126b8d80e39ff673f4ca5175ea10fc427c6ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.7/trb_0.1.7_linux_arm64.tar.gz"
      sha256 "bf3a3a6946bcf1cf0bfe6dd2aec096b8664912a0895db523afea7b2b132958a4"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.7/trb_0.1.7_linux_amd64.tar.gz"
      sha256 "195c11028c1fdd2e85e93733418aefe61c24f20a6e6f446aaeecc893d3720eca"
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
