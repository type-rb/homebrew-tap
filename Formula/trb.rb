class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.1/trb_0.4.1_darwin_arm64.tar.gz"
      sha256 "3348b4f34ac2ac3f1461d44e79caf7e4737e6044924353bcf17b2b80c326a2af"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.1/trb_0.4.1_darwin_amd64.tar.gz"
      sha256 "b751554eea215c6157eb5f74a3a4cd3b9021558a42ef8aad9ede6525f4548cc4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.1/trb_0.4.1_linux_arm64.tar.gz"
      sha256 "46c58db7edf9da5648343ab99273cdbc4eb5a72923891553fbe5a0ea9f189432"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.1/trb_0.4.1_linux_amd64.tar.gz"
      sha256 "d2b9c5f2bee8571623b66a2c22f7cfb62a20cba7ad6bf6582085826642533edf"
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
