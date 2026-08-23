class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.23/trb_0.3.23_darwin_arm64.tar.gz"
      sha256 "a61d32baac8d479e86df7372c25e76d6ed2034408fc01159997d934ce7e0d5a8"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.23/trb_0.3.23_darwin_amd64.tar.gz"
      sha256 "892e39f3252c9a0af271f02701eb75f3b1521d81f310580eabf8016fac12ecb3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.23/trb_0.3.23_linux_arm64.tar.gz"
      sha256 "0eebf94076df171daf8ef727cbd4a004710509337deb8950e790a872aa9f5d2c"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.23/trb_0.3.23_linux_amd64.tar.gz"
      sha256 "9147fae79b06ebd3ae9115024b1b7624a06abd2eb48614e79e0c50457702864e"
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
