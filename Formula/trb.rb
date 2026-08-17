class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.26/trb_0.2.26_darwin_arm64.tar.gz"
      sha256 "6e764dc9173806b65ff1295c3116f094196fe1e2c4ff5ca2e933eddcec7dc7ab"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.26/trb_0.2.26_darwin_amd64.tar.gz"
      sha256 "d8bc81c4999ea316ea013cbcd39c8cfb0ef2eced8d8555656acd2c65593d1179"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.26/trb_0.2.26_linux_arm64.tar.gz"
      sha256 "c1878d3c6b5757d95dae6996526b2917515bb4f89effcfd73904c8b91dcd2cc8"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.26/trb_0.2.26_linux_amd64.tar.gz"
      sha256 "96a0473f52713b35e7f559d8ceebb36ab0319384a5c3c0fbb04856dca7fab3a6"
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
