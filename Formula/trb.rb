class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.43/trb_0.3.43_darwin_arm64.tar.gz"
      sha256 "58627f3df2ec065d3038a8fa4a599d8046b24bce62f0c1513a0bcb6d6536bc0a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.43/trb_0.3.43_darwin_amd64.tar.gz"
      sha256 "f633d5e4206e3716d0623b83c076f5d9adae82641ae1402ce3f1dda644a6ae89"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.43/trb_0.3.43_linux_arm64.tar.gz"
      sha256 "f9c232bef20eabc091755830d13f1b25394c249f59a8e407bc5e9fd8b58325a7"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.43/trb_0.3.43_linux_amd64.tar.gz"
      sha256 "8c49dde9ab9db0244ecf4c92881f22026bdb5873ff4f1655396b62a77e582029"
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
