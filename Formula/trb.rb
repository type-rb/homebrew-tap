class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.6/trb_0.2.6_darwin_arm64.tar.gz"
      sha256 "05182dc2d2682aa0abc01089e8f4c56cc91bfe015c9fa8248abe78eb1fd9daec"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.6/trb_0.2.6_darwin_amd64.tar.gz"
      sha256 "2e04755d536dbf60e4d70aeb97bb0c45de37a42102259eea0915bb19fabf4d4d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.6/trb_0.2.6_linux_arm64.tar.gz"
      sha256 "a07e1802c00aa934093276618636299ecd70a193d02f617a7908f8d37e199c54"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.6/trb_0.2.6_linux_amd64.tar.gz"
      sha256 "fc07ba3c26802c94ab9538a305267e0243942be3451e093ef7e7576a84aef048"
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
