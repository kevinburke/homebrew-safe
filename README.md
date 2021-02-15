# homebrew-safe

Memory safe versions of various packages; in particular, C dependencies that you
would typically find, like openssl, have been replaced with versions written in
languages that prevent errors like use-after-free.

```
brew install --HEAD meterup/safe/curl
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

## Questions

If you'd like to see a package here, please open a ticket!
