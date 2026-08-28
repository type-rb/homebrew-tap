class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.48/trb_0.3.48_darwin_arm64.tar.gz"
      sha256 "7ef277293912c7e3b14f4b9b16bac31ba4f4fd886a925a2825baccecc7fbbfa9"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.48/trb_0.3.48_darwin_amd64.tar.gz"
      sha256 "d8790bec79c414597180fd3bcd99bca36b7b558af045390578433ccfa6d80b0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.48/trb_0.3.48_linux_arm64.tar.gz"
      sha256 "f163527ee17cfc2459d10c6ddcac8020c94f931b991c869741d6d497989a0a5e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.48/trb_0.3.48_linux_amd64.tar.gz"
      sha256 "463e9e5cd6db293b2b72710cf5b53b525e54f5e2a8a7be0c27775cc8d81c4de2"
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
