class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.9/trb_0.1.9_darwin_arm64.tar.gz"
      sha256 "23916c7cb6a1e538f311348ec27aaacdb91af9918f4c92fbad5031563ee7b0e7"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.9/trb_0.1.9_darwin_amd64.tar.gz"
      sha256 "3d224aa3d179516d8634d1377d9d1bbfe5af2b8bcedd1aaae45de6d7328ea8ac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.9/trb_0.1.9_linux_arm64.tar.gz"
      sha256 "0ed60fae6d95bba07da7de2bffb98718bab52871e18b370b2f78ef6d480cee0c"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.9/trb_0.1.9_linux_amd64.tar.gz"
      sha256 "84a0cf7afee1e2475ab5c12be7515ba4c9faddf64e51dc46f6b149977befa27b"
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
