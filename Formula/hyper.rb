class Hyper < Formula
  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v0.14.16.tar.gz"
  sha256 "a44d83b9aa73e933b85df4fe48a2aac08c6ac14ade39f09caee1b5142c223032"
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
