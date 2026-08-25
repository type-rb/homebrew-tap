class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.33/trb_0.3.33_darwin_arm64.tar.gz"
      sha256 "555654034c9ade7a4536086f7f456aaadb230f41354741e956979ad7ade64f5f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.33/trb_0.3.33_darwin_amd64.tar.gz"
      sha256 "b81cc87c39163b098faf86fcdaba98b46b5f716e637c81920995580278a90e62"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.33/trb_0.3.33_linux_arm64.tar.gz"
      sha256 "6a7a450c0735f630a0d0bbd96f1ee24eb5dccf3a337ee8b13194ceeab7b1d82a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.33/trb_0.3.33_linux_amd64.tar.gz"
      sha256 "572245658dd33c441a85ddd99aef240b5e06f5617fba366e078be253ba1c5452"
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
