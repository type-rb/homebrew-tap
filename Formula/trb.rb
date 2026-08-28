class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.46/trb_0.3.46_darwin_arm64.tar.gz"
      sha256 "4e0d2adeb08fda4e6885c0efd8d3d7e36be604bc13f42a26677158335a72051e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.46/trb_0.3.46_darwin_amd64.tar.gz"
      sha256 "92c77edd467ddae3fc79e0adbf5e337e09740f85c48719412e1ac73f225768c5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.46/trb_0.3.46_linux_arm64.tar.gz"
      sha256 "34fc5c2d9cfbb2ad6c7404602de63533a3dd5940588c1e2d517bb97fdec062f2"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.46/trb_0.3.46_linux_amd64.tar.gz"
      sha256 "5e4e4da8ca315453ad1153b8385cb1e30b015172ca75862439831c6f225bdf24"
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
