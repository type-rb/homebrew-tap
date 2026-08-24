class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.25/trb_0.3.25_darwin_arm64.tar.gz"
      sha256 "48820b09ad5c5b0e5f81c52a1919d784131d16a7678e776fc02482f600d65e10"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.25/trb_0.3.25_darwin_amd64.tar.gz"
      sha256 "b11b70c02155fb3144664af5fd53fd7e4d5599aa35f1de13bf119879b6875261"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.25/trb_0.3.25_linux_arm64.tar.gz"
      sha256 "5d727cf796899249bb131d82d2339006129aebc8b21b33275571f73f054d6d33"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.25/trb_0.3.25_linux_amd64.tar.gz"
      sha256 "906c038d6a8297442fab6205e3093b47334e6a14f8d2c978eac964c6e06b4990"
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
