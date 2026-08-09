class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.11/trb_0.1.11_darwin_arm64.tar.gz"
      sha256 "5d046ccd00937cf97ffa8599ee10fe8862443b9e30d5066e3f100c0d392685cd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.11/trb_0.1.11_darwin_amd64.tar.gz"
      sha256 "77f2ae949472b6a42eb567ed0d07e4e4b4ff936ed61f65a7609c18a49f3968fa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.11/trb_0.1.11_linux_arm64.tar.gz"
      sha256 "d01bec5eab67adebf37aa8f250faafe562f6b35b7c5b3e7394c7bb0fb14edd30"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.11/trb_0.1.11_linux_amd64.tar.gz"
      sha256 "4e6130cd7a16be3290c199dee1b933bda756ca3047a16ffefdf78c484f3f2ea1"
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
