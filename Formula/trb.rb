class Trb < Formula
  desc "Native compiler for the TypeRB programming language"
  homepage "https://github.com/type-rb/type-rb"
  version "0.5.0-alpha.1"
  license "MIT"

  depends_on arch: :arm64

  on_macos do
    url "https://github.com/type-rb/type-rb/releases/download/v0.5.0-alpha.1/trb_0.5.0-alpha.1_darwin_arm64.tar.gz"
    sha256 "ec76778f4ad77f8813ad7cfc61ac320be802d6f6f4f6fcb1cec934d2305b0bc3"
  end

  on_linux do
    url "https://github.com/type-rb/type-rb/releases/download/v0.5.0-alpha.1/trb_0.5.0-alpha.1_linux_arm64.tar.gz"
    sha256 "38daef594b5ab2658d6eedb329c020fb90cc0f4ece58f8524fca668eb64fa08b"
  end

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"trb"
  end

  def caveats
    <<~EOS
      The v0.5 alpha uses the Native compiler. Native builds need the system C toolchain.
      On Linux, install ld.lld from your system package manager.
      For Go, Ruby, or TypeScript source workflows, install type-rb/tap/trbg.
    EOS
  end

  test do
    assert_match "trb #{version}", shell_output("#{bin}/trb --version")
    (testpath/"trbconfig.jsonc").write <<~JSON
      {"name":"brew-smoke-test","version":"0.1.0","mode":"trb","sourceDir":"src","outDir":"build"}
    JSON
    (testpath/"src").mkpath
    (testpath/"src/main.trb").write <<~TRB
      def main()
        puts(40 + 2)
        return
      end
    TRB
    assert_equal "42", shell_output("#{bin}/trb run").strip
  end
end
