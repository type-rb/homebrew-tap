class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.15/trb_0.2.15_darwin_arm64.tar.gz"
      sha256 "3b6ef157d672cfd4ab37de2c3cb2d72678b53db99fbf3ef262272a24f664fd5a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.15/trb_0.2.15_darwin_amd64.tar.gz"
      sha256 "04c3829f9b2c8b3e08e666c42c17943a7cd56bf661ed906aed3d606a3a1d2a06"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.15/trb_0.2.15_linux_arm64.tar.gz"
      sha256 "27cf6a6b5733057113f6efb4eef03816c6fe8827b2a3f244688546d5afc0ec51"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.15/trb_0.2.15_linux_amd64.tar.gz"
      sha256 "02ecfe0fbda0c89458ba2ec2bb1650e2c07d815070eaf1817d5e6ab58cb45a7e"
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
