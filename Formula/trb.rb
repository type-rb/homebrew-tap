class Trb < Formula
  desc "Native compiler for the TypeRB programming language"
  homepage "https://github.com/type-rb/type-rb"
  version "0.5.0-alpha.2"
  license "MIT"

  depends_on arch: :arm64

  on_macos do
    url "https://github.com/type-rb/type-rb/releases/download/v0.5.0-alpha.2/trb_0.5.0-alpha.2_darwin_arm64.tar.gz"
    sha256 "567f66aa81d81f95cb5ec4f98f0c1a35ccb6cd3f5590141bc950f380d6bf05bb"
  end

  on_linux do
    url "https://github.com/type-rb/type-rb/releases/download/v0.5.0-alpha.2/trb_0.5.0-alpha.2_linux_arm64.tar.gz"
    sha256 "2febdcca2ee91857af6f04ba61b7c6634961fa5e2015c639d5947d1c11dfc3b7"
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
    reported = shell_output("#{bin}/trb --version")
    assert_match "trb #{version}", reported
    assert_equal reported, shell_output("#{bin}/trb -v")
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
