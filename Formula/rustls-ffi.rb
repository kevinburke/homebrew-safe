class RustlsFfi < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.15.4.tar.gz"
  sha256 "f9d7416a0e8a3678e4192244639ab0a5cadfd12802001dc1c43491a27f12d1bc"
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
