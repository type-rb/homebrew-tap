class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.8/trb_0.4.8_darwin_arm64.tar.gz"
      sha256 "71b68a7e3a6749ca48d5c3f48b5639fe303baab370a6b3c1de6797752f5fee00"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.8/trb_0.4.8_darwin_amd64.tar.gz"
      sha256 "8f5928d4d987062afc649a04654d8fd6fb54f4cda7e0a41b70cbcfe3bf7cce1c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.8/trb_0.4.8_linux_arm64.tar.gz"
      sha256 "96b081c915bdf4acdc1ef6fd4704b2547c0959ee17fb2309e504d2e2515c0410"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.8/trb_0.4.8_linux_amd64.tar.gz"
      sha256 "5b4ede421e7145b257491ff9e60063db9dcc290322a5ad1148a9429e671d0527"
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
