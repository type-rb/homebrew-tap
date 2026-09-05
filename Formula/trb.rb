class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.5/trb_0.4.5_darwin_arm64.tar.gz"
      sha256 "0af5e55d83cd86f885b9659facf9134016e5aa5a3b283fe9dddd0b714db2c11d"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.5/trb_0.4.5_darwin_amd64.tar.gz"
      sha256 "78e46f831b0777f0da6edd87dae09ef15c9771c206ebfcbc69a8ed20622a00a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.5/trb_0.4.5_linux_arm64.tar.gz"
      sha256 "00e17b766f13f02f8f2334bfbdd0d78a05a76baabd3db911a4298c55cd5b0b86"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.5/trb_0.4.5_linux_amd64.tar.gz"
      sha256 "34d79d8801f058d7975cede1e1bccd8fdf1410185c4ef30a267e146259b84e84"
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
