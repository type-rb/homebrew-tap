class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.9/trb_0.4.9_darwin_arm64.tar.gz"
      sha256 "8415bfbfe4b0cf630c8c91b0615b5e9ae7cf23efbb0bf4e43f405946facf09cd"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.9/trb_0.4.9_darwin_amd64.tar.gz"
      sha256 "6c59144aeab6af5012ca2097d43b32a8ae71fa98de3b050dd7ce0800daba33cd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.9/trb_0.4.9_linux_arm64.tar.gz"
      sha256 "d090ddb4df82778c2656ae6af95a6b3f12e03814d52971eff7394b7c0c9b68c4"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.4.9/trb_0.4.9_linux_amd64.tar.gz"
      sha256 "8d1c04491957404300f922632089d343a212fca27223e6b6b0fecfe592cd3d5d"
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
