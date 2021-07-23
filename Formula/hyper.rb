class Hyper < Formula
  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v0.14.11.tar.gz"
  sha256 "7b7ee07159843386f8489cacb3083f28b76bd604c36d0f5f5e7a34c6e2fd5f78"
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
