class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.17/trb_0.2.17_darwin_arm64.tar.gz"
      sha256 "830668b98262cef16e594d1485237106e4f78e66d211920ece9390c71df67692"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.17/trb_0.2.17_darwin_amd64.tar.gz"
      sha256 "021ac9204aecbc2c38a2eafaa48781a4c3d40db9545edd61b4232f7e44f99387"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.17/trb_0.2.17_linux_arm64.tar.gz"
      sha256 "42dc7554b0eadd9ec3ec1676bbeda812b53ca532ad7cf29ce827327ae28fc9fb"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.17/trb_0.2.17_linux_amd64.tar.gz"
      sha256 "1e34d4251682a020cc72b0c7322507afe568531b467047a5d68b03bda3d22cf5"
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
