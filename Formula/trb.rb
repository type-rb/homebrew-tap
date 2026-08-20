class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.7/trb_0.3.7_darwin_arm64.tar.gz"
      sha256 "ad5c464c3307943645468f11f761aa7299cb161b14fd3429484ecc3bd66a905e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.7/trb_0.3.7_darwin_amd64.tar.gz"
      sha256 "3a536a86c168b2041d1a6da19af67e408902148b2e3c70a44daf47e6674bfdfe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.7/trb_0.3.7_linux_arm64.tar.gz"
      sha256 "6e818f189cfd331334d44165b0bbfb79c3d101c24a9e5e773c8d35d818ec5b32"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.7/trb_0.3.7_linux_amd64.tar.gz"
      sha256 "0d90ede33c44fd64a4fe17f437f0814bc19e874f5960f974b150ca40eee782ee"
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
