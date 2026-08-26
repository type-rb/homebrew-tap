class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.39/trb_0.3.39_darwin_arm64.tar.gz"
      sha256 "13c5a0ca56ab6bc350810e116021fc9b133c281b2cdfcc8ba009480168825f3f"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.39/trb_0.3.39_darwin_amd64.tar.gz"
      sha256 "698777e6b7d31429b3536b56cb76eeba2b51b17807f245b0f89c01ef5e2accf9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.39/trb_0.3.39_linux_arm64.tar.gz"
      sha256 "85670910fecc4e90947bebe02d61459a286e002f26019d15ad16bb945053bfe6"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.39/trb_0.3.39_linux_amd64.tar.gz"
      sha256 "c2e4a756e35bb1d6c7b812010fedd32f18c02789c05f4d7f7dffd6cc5f84dc14"
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
