class RustlsFfi < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.15.0.tar.gz"
  sha256 "db3939a58677e52f03603b332e00347b29aa57aa4012b5f8a7e779ba2934b18b"
  head "https://github.com/rustls/rustls-ffi.git", :branch => "main"

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "capi", "install", "-vv", "--release", "--libdir", "lib", "--prefix=#{prefix}"
  end
end
