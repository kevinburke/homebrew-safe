class Hyper < Formula
  VERSION = "1.12.0".freeze

  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/refs/tags/v#{VERSION}.tar.gz"
  sha256 "d27deb550f5abcfa7a8ca865936235973f7b35f9f6f4e107356385206ea64e2c"
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
