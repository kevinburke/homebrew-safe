class Hyper < Formula
  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v0.14.14.tar.gz"
  sha256 "7b0a2bc5c5db2d6cb3abd82bd8c501a9bf362df5c307f3fd8ed0ebf5d599a4d1"
  head "https://github.com/hyperium/hyper.git"

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg hyper_unstable_ffi"
    # system "cargo", "build", "--release", "--features", "client,http1,http2,ffi", "--target-dir", buildpath
    system "cargo", "build", "--release", "--features", "client,http1,http2,ffi", "--target-dir", buildpath
    (prefix/"lib").install Dir["release/libhyper.a"]
    (prefix/"lib").install Dir["release/libhyper.d"]
    (prefix/"lib").install Dir["release/libhyper.dylib"]
    (prefix/"lib").install Dir["release/libhyper.rlib"]
    (prefix/"include").install Dir["capi/include/hyper.h"]
  end
end
