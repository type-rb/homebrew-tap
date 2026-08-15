class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.19/trb_0.2.19_darwin_arm64.tar.gz"
      sha256 "f1b5d912ce4382a0f5acec9c12179f3234c6b17829f74cf19f6f3433faa0e132"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.19/trb_0.2.19_darwin_amd64.tar.gz"
      sha256 "754f1d767869f67851f87740276b9ccc2cdf021fb901ab522cd86b26fbb9b322"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.19/trb_0.2.19_linux_arm64.tar.gz"
      sha256 "2ee0300515ca85081f1c054f9554a2c05b0682281132d25992057a8f08caeaf6"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.19/trb_0.2.19_linux_amd64.tar.gz"
      sha256 "a79a232c3784b206867d7842808cc840f3a79cbbaae0e97ae8798fb06c2ba1cd"
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
