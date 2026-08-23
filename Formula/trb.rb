class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.21/trb_0.3.21_darwin_arm64.tar.gz"
      sha256 "55cb91c1f1cf21d635fe0b5c6a3acd69a927ffa6ce5f22dca0873fb562f73ad3"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.21/trb_0.3.21_darwin_amd64.tar.gz"
      sha256 "16301803afb2f7263823e6ed8d290aa4176f19b551e2005b0fe3dce98b36265d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.21/trb_0.3.21_linux_arm64.tar.gz"
      sha256 "8827245b1a261deac250925fbb2c5a23ce75b08e20517d19bf450c79f93d4141"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.21/trb_0.3.21_linux_amd64.tar.gz"
      sha256 "e8a8fee41ef5df3ebaa8409534f57ace8b7837fef6d4927870c4f2ac8c7e0dad"
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
