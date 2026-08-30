class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.2/trb_0.4.2_darwin_arm64.tar.gz"
      sha256 "7f40364339c7afe258c4c8cbba22cc132d374d1b92b2d09912aae973a4c21ca9"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.2/trb_0.4.2_darwin_amd64.tar.gz"
      sha256 "3e7b4f37db8d54fd339f701f54846e0eac6f9c58ed31c7731586fe39dbd00bb0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.2/trb_0.4.2_linux_arm64.tar.gz"
      sha256 "9c9c11058204aa673a7b9d84d7f7107f441e8e7ad308c65a2cf5405a92455bff"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.2/trb_0.4.2_linux_amd64.tar.gz"
      sha256 "2e000a3be078ff7985a501533a073c1132123fd5240836b31c12af2660b863cf"
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
        IO.puts("installed with Homebrew")
        return
      end
    TRB

    system bin/"trb", "fmt", testpath/"src/main.trb"
    system bin/"trb", "build", "--config", testpath/"trbconfig.jsonc"
    assert_path_exists testpath/"build/main.go"
    assert_match "fmt.Println(\"installed with Homebrew\")", (testpath/"build/main.go").read
  end
end
