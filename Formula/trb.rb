class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.3/trb_0.4.3_darwin_arm64.tar.gz"
      sha256 "71831e709ec09c9d216929ed7926c7591a24e4fd0b0558f8ad436d19cae82154"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.3/trb_0.4.3_darwin_amd64.tar.gz"
      sha256 "d06c7277132f3895de4264ebd1210e373364ed5bf0720ae43a065d3e4d83f98e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.3/trb_0.4.3_linux_arm64.tar.gz"
      sha256 "f210af8161fc22281a4685b249f42bfc7a12740b401a9917fb76da15d1a1f36e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.3/trb_0.4.3_linux_amd64.tar.gz"
      sha256 "a4eab73cdeeaa7cd88feaf6f323aaeaae005332b095922ba2691ea45ca9c560c"
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
