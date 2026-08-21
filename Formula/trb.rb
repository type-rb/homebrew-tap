class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.9/trb_0.3.9_darwin_arm64.tar.gz"
      sha256 "bdbd7aa6c05c47f00500fb1bce4c023f2741a3b497808418b2dab1ed9421be3a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.9/trb_0.3.9_darwin_amd64.tar.gz"
      sha256 "f8bd32b7d39e2c5c214d8691340797e7f68be4dce7ea0bb3ca2c60bd7f4ee021"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.9/trb_0.3.9_linux_arm64.tar.gz"
      sha256 "63ee5e96f9c8126e24af3968668c31a21d3edf9ff37d2649f8932c3ba6aaf1cd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.9/trb_0.3.9_linux_amd64.tar.gz"
      sha256 "2acf490356cd6191b926d05946778a06cde0d246e25480e118fddb1be8440bd2"
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
