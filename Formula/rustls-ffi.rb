class RustlsFfi < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.15.5.tar.gz"
  sha256 "5be0a6abd612e067349f6f4f1469672685a582d40c1469c28662edceb9273786"
  head "https://github.com/rustls/rustls-ffi.git", :branch => "main"

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "capi", "install", "-vv", "--release", "--libdir", "lib", "--prefix=#{prefix}"
  end

  test do
    assert_predicate include/"rustls.h", :exist?
    assert_predicate lib/"librustls.a", :exist?
    assert_predicate lib/"librustls.dylib", :exist?
    assert_predicate lib/"pkgconfig"/"rustls.pc", :exist?
  end
end
