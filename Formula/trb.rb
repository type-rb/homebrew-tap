class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.28/trb_0.2.28_darwin_arm64.tar.gz"
      sha256 "da614ab7092aea032500d1fc3071698ea774cfe0106c9475c3d50a4fd7215fc7"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.28/trb_0.2.28_darwin_amd64.tar.gz"
      sha256 "c48720f8546d329c06b2f59363d617c98ea10f252fd40629e00000898feea2c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.28/trb_0.2.28_linux_arm64.tar.gz"
      sha256 "d6215c4920a3a09199abc6abadb3e743a79a488e7846bc5e92e5b99eb98e085b"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.28/trb_0.2.28_linux_amd64.tar.gz"
      sha256 "c832282ec02d2576a5a47f94278a3b63a7fed5063ecb0c314de4288371ccd8c6"
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
