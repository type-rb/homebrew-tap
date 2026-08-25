class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.32/trb_0.3.32_darwin_arm64.tar.gz"
      sha256 "6f0addfb8f0db8808fec432d7933817723133e71a7cd11fc8f3fc755049fccc9"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.32/trb_0.3.32_darwin_amd64.tar.gz"
      sha256 "02b34e93c2c6b881c5abbb4510c31d8bbf67f9352bc6c7a89e04c2fef67fc9d6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.32/trb_0.3.32_linux_arm64.tar.gz"
      sha256 "fd291ab77f25d0bcece9cae1f043b3fe484e349374e2cfdd4daa5433db1d151e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.32/trb_0.3.32_linux_amd64.tar.gz"
      sha256 "31a53c6040b8d1032ec1084b59043f40617b8ebdb2ecbfcb72d374955b9d7fbc"
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
