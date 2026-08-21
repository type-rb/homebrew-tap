class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.10/trb_0.3.10_darwin_arm64.tar.gz"
      sha256 "7f00faaecfcb76e7b006369b79d64c3a97a4e6def05de1817396e496491157f3"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.10/trb_0.3.10_darwin_amd64.tar.gz"
      sha256 "106decc31719d70a785d2d323caa223edc8858ab0b0411d00ff8be92d0606dab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.10/trb_0.3.10_linux_arm64.tar.gz"
      sha256 "d148e03ca899b6dae778c144e26b2dd836e3f35bb75afacbd8376181e914841b"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.10/trb_0.3.10_linux_amd64.tar.gz"
      sha256 "46ace519e4937f81d123620e1a59730a1da218af73e51a53f2ca27ae74a80d0f"
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
