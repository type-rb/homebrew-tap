class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.27/trb_0.3.27_darwin_arm64.tar.gz"
      sha256 "2007af5e73e2c942f91cf4263828390a1d7055f53df982a362514a97d6b963dd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.27/trb_0.3.27_darwin_amd64.tar.gz"
      sha256 "3dd83c4f31a90e9f6e94fa9bdb8548a8ef9268b783df3fdf5519dbcb77a17f68"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.27/trb_0.3.27_linux_arm64.tar.gz"
      sha256 "f1de97f27972871e95f70c13df2d4cf4f908353e278accf1aab2062a66b69871"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.27/trb_0.3.27_linux_amd64.tar.gz"
      sha256 "5078866c77c71cfa1bb71c5955cd978fb3cf975460621f7ed8fcaa753182978c"
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
