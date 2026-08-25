class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.26/trb_0.3.26_darwin_arm64.tar.gz"
      sha256 "d0398cc9190a394c838fb7af8003a5491542ae86669215479129bdc01d75bba7"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.26/trb_0.3.26_darwin_amd64.tar.gz"
      sha256 "366421b9f7740d8736aeb317becce9384f6bd6851d473527fed36cb3dee626c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.26/trb_0.3.26_linux_arm64.tar.gz"
      sha256 "72073e0c144bbf0cb3639e03fd002307955d689d3d5e05c925bc8dc1ecb84d74"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.26/trb_0.3.26_linux_amd64.tar.gz"
      sha256 "e1f688627a06bcd7584359a352032bae87af2da61812c74bad45dedea31e569b"
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
