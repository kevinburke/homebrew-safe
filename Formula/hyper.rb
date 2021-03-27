class Hyper < Formula
  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v0.14.5.tar.gz"
  sha256 "fec2085e36488c9bd34bfec5034c506f928e7d5ee6a8584f35dbec4f0a503b98"
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
