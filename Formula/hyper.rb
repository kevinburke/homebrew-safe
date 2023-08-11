class Hyper < Formula
  VERSION = "1.0.0-rc.4"

  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v#{VERSION}.tar.gz"
  sha256 "c23984d1057e41b2d38b1a87f8fca03303b160a45b328ccddc2fcaa721e1603e"
  head "https://github.com/hyperium/hyper.git"

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg hyper_unstable_ffi"
    # system "cargo", "build", "--release", "--features", "client,http1,http2,ffi", "--target-dir", buildpath
    system "cargo", "rustc", "--features", "client,http1,http2,ffi", "-Z", "unstable-options",
      "--release", "--crate-type", "cdylib", "--target-dir", buildpath
    (prefix/"lib").install Dir["release/libhyper.d"]
    (prefix/"lib").install Dir["release/libhyper.rlib"]
    (prefix/"lib").install Dir["release/deps/libhyper.dylib"]
    (prefix/"include").install Dir["capi/include/hyper.h"]
  end
end
