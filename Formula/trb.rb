class Trb < Formula
  desc "Statically typed language that targets Go, Ruby, and TypeScript"
  homepage "https://github.com/type-rb/type-rb"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.42/trb_0.3.42_darwin_arm64.tar.gz"
      sha256 "eec8e499dce1bd97b81f1bf33dc339bc65cccba219779ba231e1c491e83fda73"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.42/trb_0.3.42_darwin_amd64.tar.gz"
      sha256 "223637fa98105b2aab2a6d2bd7eb86a412742075fceac1fcf33450ff34dd2951"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.42/trb_0.3.42_linux_arm64.tar.gz"
      sha256 "620cda3914987a7321afb39421bd7f4de1ec118710e0ef449217f91b906f655e"
    end
    on_intel do
      url "https://github.com/type-rb/type-rb/releases/download/v0.3.42/trb_0.3.42_linux_amd64.tar.gz"
      sha256 "f5df3f7a54ee9e623b5669e41fca04102dbadeacaa894d7bfa2e670abb3bbce2"
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
