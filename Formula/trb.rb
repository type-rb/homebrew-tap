class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.23/trb_0.2.23_darwin_arm64.tar.gz"
      sha256 "f83148d330cd395d7277e6570228c5e5d2036fe3e9452c0fc1d4b8950fb14897"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.23/trb_0.2.23_darwin_amd64.tar.gz"
      sha256 "ff76d5b57d74f5e857227cf9022cb6d63a9577e098699bf78e95f4129ccab2da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.23/trb_0.2.23_linux_arm64.tar.gz"
      sha256 "ba9c8ebbc332d724e33f642be6bc7578ca8f6edbf021c6ef06580d397c9e42d8"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.23/trb_0.2.23_linux_amd64.tar.gz"
      sha256 "b7d586705c40f26441e33e88b71c358d76a382a5876d2b0462b7c4c687dc4f52"
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
