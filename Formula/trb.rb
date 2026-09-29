class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.10/trb_0.4.10_darwin_arm64.tar.gz"
      sha256 "ecd6b268b86ea10567b31a6c50780709e987be2f3747842f5e26598ed0d78028"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.10/trb_0.4.10_darwin_amd64.tar.gz"
      sha256 "90e61cb613aeb0f042401dff1b515a185b29e0067c8cbe0c146bb27789cd5ec4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.10/trb_0.4.10_linux_arm64.tar.gz"
      sha256 "c707e39bce5c4c4a498bf858844d04c38951b4f51d367b3e66012a68d942ac03"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.10/trb_0.4.10_linux_amd64.tar.gz"
      sha256 "ebd3b20bbdafabaff542953963685bbef840b65c954a738335873ca4442a8f0d"
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
          "version": "1.27"
        }
      }
    JSON
    (testpath/"src").mkpath
    (testpath/"src/main.trb").write <<~TRB
      import trb/std/io

      def main()
        IO.puts("installed with Homebrew")
        return
      end
    TRB

    system bin/"trb", "fmt", testpath/"src/main.trb"
    system bin/"trb", "build", "--config", testpath/"trbconfig.jsonc"
    entries = Dir[testpath/"build/trb/entry/*/main.go"]
    assert_equal 1, entries.length
    sources = Dir[testpath/"build/trb/application/*.go"].map { |path| File.read(path) }.join("\n")
    assert_match "fmt.Println(\"installed with Homebrew\")", sources
  end
end
