class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.0/trb_0.2.0_darwin_arm64.tar.gz"
      sha256 "99fc48777d4617a7af1516909d0b34a46679b1d1ad88d154ee2b1da5037ca36f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.0/trb_0.2.0_darwin_amd64.tar.gz"
      sha256 "a3bb410d8604deacabf5753543545ccd39598b8d11898cd343fb8200ec6bd79d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.0/trb_0.2.0_linux_arm64.tar.gz"
      sha256 "f361e954bd35b7207f59ef0c3b5a9dd7f3f8c7fb65e03405548eaa9f99d8383a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.0/trb_0.2.0_linux_amd64.tar.gz"
      sha256 "2e8b7c7a731c9a1b6b2202591f589a22c3570edb6238bf68495fb69a79e95c6d"
    end
  end

  def install
    bin.install "trb"
  end

  test do
    assert_match "trb #{version}", shell_output("#{bin}/trb version")

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
