class Hyper < Formula
  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v0.14.6.tar.gz"
  sha256 "d609a25418a661646dd6cfbbba283e1c8a977734779a2a52c35c41ce21af050d"
  head "https://github.com/hyperium/hyper.git"

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg hyper_unstable_ffi"
    system "cargo", "build", "--release", "--features", "client,http1,http2,ffi", "--target-dir", buildpath
    lib.install Dir["release/libhyper.a"]
    lib.install Dir["release/libhyper.dylib"]
    include.install Dir["capi/include/hyper.h"]
  end
end
