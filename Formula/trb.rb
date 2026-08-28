class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.45/trb_0.3.45_darwin_arm64.tar.gz"
      sha256 "b97c1514b12d1ee8e17f14ebaca3e09e93d7420b47db213ee9fe0a8ba4a253c7"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.45/trb_0.3.45_darwin_amd64.tar.gz"
      sha256 "26e6bdd9fc6448dd2e7dd0adb562ca217a5786ada2217f8041f36d00f98daeee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.45/trb_0.3.45_linux_arm64.tar.gz"
      sha256 "9a9f387160286a1b4fdc38a3d4b850205cf664a8009bb7cc19a44766f1c81955"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.45/trb_0.3.45_linux_amd64.tar.gz"
      sha256 "b11ed9de19fd33f372d74de4ff6a2f2f232419b2e1de083db9d1c5a2c65e8fe1"
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
