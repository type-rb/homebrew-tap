class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.16/trb_0.2.16_darwin_arm64.tar.gz"
      sha256 "dad6579be0c30b105b2e95b7fc91889014cabf20f63d014ed8730ab9cd7f653e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.16/trb_0.2.16_darwin_amd64.tar.gz"
      sha256 "205501891bef6389c3a4b2806649a5690545b29c1033ec3260b8482c4073af77"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.16/trb_0.2.16_linux_arm64.tar.gz"
      sha256 "2bffe62984254cc2ea0a01ab6b23acf86baf3f6827874e52095f4cbd78ba4032"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.16/trb_0.2.16_linux_amd64.tar.gz"
      sha256 "f3e5b3287c5a2da105c107265e36cb8e6cd3633afa3232b2aabdad920e4aabad"
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
