class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.11/trb_0.3.11_darwin_arm64.tar.gz"
      sha256 "572ee646cc377961385d06a77a098807e30e34e8e1bb717bf1ca368d6e675af9"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.11/trb_0.3.11_darwin_amd64.tar.gz"
      sha256 "e70359315a2f5312d34d6f08c960ca755b5fd59375773719d18ae1b666fcf2da"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.11/trb_0.3.11_linux_arm64.tar.gz"
      sha256 "df634878bff0559b2595104ddf79f8a2d860ae48e5192a438cf2fe7f115f4537"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.11/trb_0.3.11_linux_amd64.tar.gz"
      sha256 "3f62850451c13ff4c4c2594f7789c7475fdfc580fcc847b609ee01e78b6b2296"
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
