class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.19/trb_0.3.19_darwin_arm64.tar.gz"
      sha256 "b63512bd3f56ccbf4665157871da7e1d93019c49b9b15fd1139fbd835a0e40aa"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.19/trb_0.3.19_darwin_amd64.tar.gz"
      sha256 "5fc2a6de21f2ccb94af0811fc8255f861d033a8806731962f803583517c11c74"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.19/trb_0.3.19_linux_arm64.tar.gz"
      sha256 "ae61162491532c80640b45f7069a5e60e68756fac826af3c9ecb180f2a4cb65b"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.19/trb_0.3.19_linux_amd64.tar.gz"
      sha256 "2650fafa784e589912389a77adaa4e01288624f84210bf6bc128e42826e0146b"
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
