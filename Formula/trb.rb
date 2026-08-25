class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.28/trb_0.3.28_darwin_arm64.tar.gz"
      sha256 "863271393a137f1792493ba391fb790a2fbcf3c16ec9c190f2d4230760e127c6"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.28/trb_0.3.28_darwin_amd64.tar.gz"
      sha256 "71d78a73a237fa072965cfdf62c9f4e863392e9961618453fb2b1f2b90524331"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.28/trb_0.3.28_linux_arm64.tar.gz"
      sha256 "ec1b818659826fe79d29f0bbe281dc25a4ecd17b2f873db7e12473d37c654a9d"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.28/trb_0.3.28_linux_amd64.tar.gz"
      sha256 "d514edf6bd12e592f0759b135e3627701791b1e22307529349fc9e671e9db54b"
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
