class RustlsFfi < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.15.1.tar.gz"
  sha256 "1a1066b4d5729469a93a0fd48c005667e836f8f56cf20361613b5a8a00684369"
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
