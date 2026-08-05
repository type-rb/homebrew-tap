class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.4/trb_0.1.4_darwin_arm64.tar.gz"
      sha256 "84e3b158d337b0899e3322f850c80d4a6110cc84ca858e5e887208f751e5db97"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.4/trb_0.1.4_darwin_amd64.tar.gz"
      sha256 "327014beba2627d328b55c3336d395416f8f0b88851a6e50d9cf26d425c57fa3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.4/trb_0.1.4_linux_arm64.tar.gz"
      sha256 "e844e5c1c92bb8059cff3d263f0f352dd87271b3339cc273cc9d7547c94f88a2"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.4/trb_0.1.4_linux_amd64.tar.gz"
      sha256 "03f0eb6abef3bd135dec335c01e05b74f2620a7e87a6a4155d7a1b4a4f816c97"
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
