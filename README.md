# homebrew-safe

Memory safe versions of various packages; in particular, C dependencies that you
would typically find, like openssl, have been replaced with versions written in
languages that prevent errors like use-after-free.

```
brew install kevinburke/safe/curl
brew install kevinburke/safe/git
```

For more on why this is important, see
https://alexgaynor.net/2020/may/27/science-on-memory-unsafety-and-security/ .

## Supported Packages

#### curl

Curl is compiled with the rustls and Hyper backend instead of openssl, which
means that TLS connections are made with Rust. Note that this means TLS 1.1 and
below are not supported.

#### git

Git is compiled with libcurl from this repository.

## How to check the right versions were compiled in?

Use `objdump -p <binary>` to inspect the symbols for a given binary - they
should point to the Homebrew compiled libs instead of e.g. `/usr/lib/curl.dylib`
which is the default Mac version.

### Brotli security updates

The curl formula requires Brotli 1.2.1 or newer to address
[CVE-2026-111497](https://github.com/google/brotli/releases/tag/v1.2.1).
The build checks the installed decoder's pkg-config metadata and explicitly
selects Homebrew's Brotli prefix. The formula test checks the decoder version
reported by the built curl at runtime; CI runs this test. Git uses Brotli through
this tap's libcurl, and its macOS formula test verifies that linkage.

To update an existing installation:

```bash
set -euo pipefail
brew update
brew upgrade brotli
brew reinstall --build-from-source kevinburke/safe/curl
brew test kevinburke/safe/curl
brew test kevinburke/safe/git
brew linkage kevinburke/safe/curl
brew linkage kevinburke/safe/git
```

Git does not need rebuilding when it dynamically links to the updated libcurl.
Restart long-running processes using these libraries after upgrading them.

## Questions

If you'd like to see a package here, please open a ticket!
