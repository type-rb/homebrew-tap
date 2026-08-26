class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.41/trb_0.3.41_darwin_arm64.tar.gz"
      sha256 "952855d47336b50409cab8d9992c52f894fcfeab335e45aa78dbbfb0b3a4e88b"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.41/trb_0.3.41_darwin_amd64.tar.gz"
      sha256 "16b0eebfe590e401fa7fae6e8aafa9a880cba41be851470caa90d11d76005170"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.41/trb_0.3.41_linux_arm64.tar.gz"
      sha256 "c9b059907b8c379debf4b209f82bc2bcb5a74091dd821455d3b634b5b50519e8"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.41/trb_0.3.41_linux_amd64.tar.gz"
      sha256 "c52423b93f7e8f03ecd5c8f06dea5ed9a06bc67400bc5695ba4946f37e8f9595"
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
