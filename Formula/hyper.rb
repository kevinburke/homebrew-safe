class Hyper < Formula
  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v0.14.15.tar.gz"
  sha256 "0b72a6ac1f6ba1f01dbe2df5296562420b6df08e9f88df2e72370d654766b0fd"
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
