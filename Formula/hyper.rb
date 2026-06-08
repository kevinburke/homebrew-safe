class Hyper < Formula
  VERSION = "1.10.1".freeze

  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/refs/tags/v#{VERSION}.tar.gz"
  sha256 "9a58529df9a322da021c082a2cde01b9d7837a30a8a886cb007e507560c6bbb5"
  head "https://github.com/hyperium/hyper.git"

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg hyper_unstable_ffi"
    system "cargo", "rustc", "--features", "client,http1,http2,ffi",
      "--release", "--crate-type", "cdylib", "--target-dir", buildpath
    (prefix/"lib").install "release/libhyper.d"
    (prefix/"lib").install "release/deps/libhyper.dylib"
    (prefix/"include").install "capi/include/hyper.h"
  end

  test do
    assert_path_exists include/"hyper.h"
    assert_path_exists lib/"libhyper.dylib"
  end
end
