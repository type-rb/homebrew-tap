class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.1/trb_0.2.1_darwin_arm64.tar.gz"
      sha256 "37c6c77607f76dafa28f8e2001aee8678252e7229b98d380bc4a89ccf086dccc"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.1/trb_0.2.1_darwin_amd64.tar.gz"
      sha256 "c24026723216981335fffdd07a915adb6c9561f71078c5a4d8cc83e860a02616"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.1/trb_0.2.1_linux_arm64.tar.gz"
      sha256 "a550d25b4126b5de7d886f2a04fcc767184cbacb6329a62ef73a84e4c1ee34a6"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.1/trb_0.2.1_linux_amd64.tar.gz"
      sha256 "16c77d0e12977ebe2c8eca361cd77f6c82e1893a8173056fd24496dc6cdc1289"
    end
  end

  def install
    bin.install "trb"
  end

  test do
    assert_match "trb #{version}", shell_output("#{bin}/trb version")

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
