class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.5/trb_0.1.5_darwin_arm64.tar.gz"
      sha256 "29e4a3383300750ad8fd5fda774e5342648277b53f2a368ee60e40423e438b83"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.5/trb_0.1.5_darwin_amd64.tar.gz"
      sha256 "8563f582ca7955bcd6acdd64711d09268aedd58a918580f623982fd4ef0a5822"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.5/trb_0.1.5_linux_arm64.tar.gz"
      sha256 "7beb22a52177f8ce19bbd1c0c91e427affa07c282b29e853fc42e6b480192b9a"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.5/trb_0.1.5_linux_amd64.tar.gz"
      sha256 "5425b00c896609bc5e7aeead920ee2233242c4b9050ee24b0e881c7ac643b24e"
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
