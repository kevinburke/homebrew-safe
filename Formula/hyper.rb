class Hyper < Formula
  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v0.14.22.tar.gz"
  sha256 "b5a158534d462a8eb8412be8dd35d058f062c0f34bfbf4f5f7f7464ea980fee5"
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
