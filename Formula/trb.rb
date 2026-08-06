class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.6/trb_0.1.6_darwin_arm64.tar.gz"
      sha256 "030c4125a740840e19301f70ebf04cf6b6e3523cb11c6e4a46474a1fd0cb2a5e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.6/trb_0.1.6_darwin_amd64.tar.gz"
      sha256 "808596ca33b0dc5507839e05a0d18449a7f35522bc071255312773b1ab5c612c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.6/trb_0.1.6_linux_arm64.tar.gz"
      sha256 "9f7681ea7e64597497b48a9629ceb80c3aab3d6020088fe9942dd512ecfd22eb"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.1.6/trb_0.1.6_linux_amd64.tar.gz"
      sha256 "f564579f7cf7f947195133df1f3efc82b7d185958e84058867d3479ab2ed0de8"
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
