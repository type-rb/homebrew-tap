# TypeRB Homebrew tap

On Arm64 macOS or Linux, install or upgrade the TypeRB Native compiler:

```sh
brew install type-rb/tap/trb
brew upgrade type-rb/tap/trb
```

The `trb` formula follows TypeRB's v0.5 alpha releases until the stable
v0.5.0 release. Native executable builds use the system C toolchain and
require `ld.lld` on Linux.

Install the Go implementation on Arm64 or x86-64 macOS and Linux:

```sh
brew install type-rb/tap/trbg
```

Both commands can be installed together. Use `trbg` for Go, Ruby, and
TypeScript source workflows. See the
[Native release notes](https://github.com/type-rb/type-rb/releases/tag/v0.5.0-alpha.1)
and the [Go release archives](https://github.com/type-rb/type-rb-go/releases).

The [v0.4.11 binaries](https://github.com/type-rb/type-rb/releases/tag/v0.4.11)
remain available through the original release.
