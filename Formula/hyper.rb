class Hyper < Formula
  VERSION = "1.9.0"

  desc "HTTP implementation for Rust"
  homepage "https://github.com/hyperium/hyper"
  url "https://github.com/hyperium/hyper/archive/v#{VERSION}.tar.gz"
  sha256 "18aa8a8978d4d026ed9e3c8dbb09056ad074c123510b01c951197334ec0e4b88"
  head "https://github.com/hyperium/hyper.git"

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg hyper_unstable_ffi"
    system "cargo", "rustc", "--features", "client,http1,http2,ffi",
      "--release", "--crate-type", "cdylib", "--target-dir", buildpath
    (prefix/"lib").install Dir["release/libhyper.d"]
    (prefix/"lib").install Dir["release/deps/libhyper.dylib"]
    (prefix/"include").install Dir["capi/include/hyper.h"]
  end

  test do
    assert_predicate include/"hyper.h", :exist?
    assert_predicate lib/"libhyper.dylib", :exist?
  end
end
