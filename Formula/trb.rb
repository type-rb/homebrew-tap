class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.37/trb_0.3.37_darwin_arm64.tar.gz"
      sha256 "432d2f2839bc32260607a4882ba6c3738d4b7bf558ad851427a1b3d8dbba0009"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.37/trb_0.3.37_darwin_amd64.tar.gz"
      sha256 "af31d476d72c69146288673549764b31b5021cf87765080aae71d69c0bcd2a1e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.37/trb_0.3.37_linux_arm64.tar.gz"
      sha256 "58c737bcfd5d10f89693839bd51f29fbcc68942e8cff0609e94b79b9260b8a3d"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.37/trb_0.3.37_linux_amd64.tar.gz"
      sha256 "f98cd5018ddcb66bd3a7927e78f580fce8e10b3b3ae2f64e9b8295e6380f969a"
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
