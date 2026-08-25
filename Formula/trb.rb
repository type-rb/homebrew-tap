class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.29/trb_0.3.29_darwin_arm64.tar.gz"
      sha256 "f818804c669592ddb3ebd68eebbb1a4c3f8c8fd562cbbc2a566c8381fca44329"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.29/trb_0.3.29_darwin_amd64.tar.gz"
      sha256 "ea3062efd0b4b99ebbb7998e89c2e651e8241e30b1d31346d5b987c7ea935009"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.29/trb_0.3.29_linux_arm64.tar.gz"
      sha256 "d001b28d7783acb517162a7fba04702af6cae5c382b18be8cf6b53c98d9f2217"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.29/trb_0.3.29_linux_amd64.tar.gz"
      sha256 "e32af90a9364dfa8d1a3b97611737e10e943257a619531563c678abcaef683cb"
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
