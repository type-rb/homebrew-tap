class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.8/trb_0.3.8_darwin_arm64.tar.gz"
      sha256 "cb0c922eda9bcb9bfb6c7ad6fccccf00fe9ec5758465843f2f0c0f4f6e1b2009"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.8/trb_0.3.8_darwin_amd64.tar.gz"
      sha256 "1ef3e866910067ef58ed4b3a40a324525d85965b0addf1caf2b5e0bfc2c2304d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.8/trb_0.3.8_linux_arm64.tar.gz"
      sha256 "de80e483ffead247ca55515792859e419523c8335764f0dd4b2458df8816629a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.8/trb_0.3.8_linux_amd64.tar.gz"
      sha256 "02220cc2b254521599285cf56299656821de998b241b309b793eb38e511fd8f0"
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
