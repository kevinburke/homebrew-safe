class Hyper < Formula
  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v0.14.7.tar.gz"
  sha256 "7f497ff1ffbf3d7927edc228100aa13512a9c8e60de442426b8dd36442ddddc5"
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
