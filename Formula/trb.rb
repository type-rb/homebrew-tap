class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.13/trb_0.2.13_darwin_arm64.tar.gz"
      sha256 "557b0bfadf11388da552e18fadfb730b09c20049eb8cfcc5f90905d1c5731423"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.13/trb_0.2.13_darwin_amd64.tar.gz"
      sha256 "fb16050b500fda84b3026d112d88fc8ed89f988b5087a10e55039859381a339f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.13/trb_0.2.13_linux_arm64.tar.gz"
      sha256 "32dae69324ad9aeecdd32c353f38290deafefdaf037be69ee7352b94c095c271"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.2.13/trb_0.2.13_linux_amd64.tar.gz"
      sha256 "b89d59a9f91e0bd7323b8c36d67f6d6d5dd16cca9dbe23ed553be629f0590bee"
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
