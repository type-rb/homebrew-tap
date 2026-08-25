class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.35/trb_0.3.35_darwin_arm64.tar.gz"
      sha256 "d58761d29266117a39c300cf71b2d2c57dce84791ef7c92474b22fa90c97fd04"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.35/trb_0.3.35_darwin_amd64.tar.gz"
      sha256 "27ab246419f7f605ac362b044681bcc2d1c64197af2d302b56ad1b40a9e3545a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.35/trb_0.3.35_linux_arm64.tar.gz"
      sha256 "65d1b0c4750285e468c99bc2cabea9bb0a44c614917ab978bea70c4aebaf1622"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.35/trb_0.3.35_linux_amd64.tar.gz"
      sha256 "c1a19703d64b65ac6ae840e682a68cb897aefcda5051878e2015955a406f919a"
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
