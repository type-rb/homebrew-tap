class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.7/trb_0.4.7_darwin_arm64.tar.gz"
      sha256 "58865baecfe56e4f0f06c38db892656af0724ad34e7b19f26636a7182acd9b1e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.7/trb_0.4.7_darwin_amd64.tar.gz"
      sha256 "753e34cbd4b8bdeec6aea662e81fe25b84096844f76732f501dc5927e56149bb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.7/trb_0.4.7_linux_arm64.tar.gz"
      sha256 "74bacebb90c38d4f2d557aba8b0bee7ecaac8eb45d6e9d39285099154861d35b"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.7/trb_0.4.7_linux_amd64.tar.gz"
      sha256 "8a6b8f3e5d94c11717cc46e3fa8c682ace6bfd657c8189dfb17ecc801f378030"
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
        IO.puts("installed with Homebrew")
        return
      end
    TRB

    system bin/"trb", "fmt", testpath/"src/main.trb"
    system bin/"trb", "build", "--config", testpath/"trbconfig.jsonc"
    assert_path_exists testpath/"build/main.go"
    assert_match "fmt.Println(\"installed with Homebrew\")", (testpath/"build/main.go").read
  end
end
