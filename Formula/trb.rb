class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.22/trb_0.2.22_darwin_arm64.tar.gz"
      sha256 "58acf1567a2d07155bb49c8d4bc717ff491bbc2ccd12555f6fb79f86ff9cd11a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.22/trb_0.2.22_darwin_amd64.tar.gz"
      sha256 "b274a0fe264f07d66c26894a3d33041c39bc0ab960f82e5b782a2a0f0a27961c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.22/trb_0.2.22_linux_arm64.tar.gz"
      sha256 "5c3cf726360bf7064975b2477c524772756dd5775aaa10dc18fedfb251133108"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.22/trb_0.2.22_linux_amd64.tar.gz"
      sha256 "649d850c7ec68be71c288ff2fe42552b35cc95abbfe6dc833441063e645f6cb0"
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
