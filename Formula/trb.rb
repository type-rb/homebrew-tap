class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.17/trb_0.3.17_darwin_arm64.tar.gz"
      sha256 "c18ab2e6bf7eee34ce666e60ec56ca47448a18abb8b09e1da1c9eccd848edc38"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.17/trb_0.3.17_darwin_amd64.tar.gz"
      sha256 "ced4cbecd53adabd01124e23030bdbd9f3562e43bc237712c6844edb87e05528"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.17/trb_0.3.17_linux_arm64.tar.gz"
      sha256 "49a980034d4b1856e7e620f391f3a8302f54907cd47fae92d24859b54694a5bb"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.17/trb_0.3.17_linux_amd64.tar.gz"
      sha256 "659330c57191c50373d0b253505474dcc30de9f4d4b9cfc587d81fc1d04663b6"
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
