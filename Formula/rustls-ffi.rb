class RustlsFfi < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.15.3.tar.gz"
  sha256 "f1612b770be384ff23d5647c815ac3f47734e2ec3c4a03cabc453723461234bc"
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
