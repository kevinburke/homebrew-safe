class Hyper < Formula
  VERSION = "1.3.1"

  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v#{VERSION}.tar.gz"
  sha256 "b021ef7f0bd3e3481fab10e541aa21fe65af2055055e3149787b482d8b8b4e4b"
  head "https://github.com/hyperium/hyper.git"

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg hyper_unstable_ffi"
    # system "cargo", "build", "--release", "--features", "client,http1,http2,ffi", "--target-dir", buildpath
    system "cargo", "rustc", "--features", "client,http1,http2,ffi",
      "--release", "--crate-type", "cdylib", "--target-dir", buildpath
    (prefix/"lib").install Dir["release/libhyper.d"]
    (prefix/"lib").install Dir["release/libhyper.rlib"]
    (prefix/"lib").install Dir["release/deps/libhyper.dylib"]
    (prefix/"include").install Dir["capi/include/hyper.h"]
  end
end
