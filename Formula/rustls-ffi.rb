class RustlsFfi < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.9.0.tar.gz"
  sha256 "6fba6e1e5cf9fcab08ce8bf3bf50e5f1d23635d37931f670c095287a86af5b2a"
  head "https://github.com/rustls/rustls-ffi.git", :branch => "main"

  depends_on "rust" => :build

  def install
    # https://github.com/rustls/rustls-ffi/issues/113
    ENV.append "PROFILE", "release"
    system "make"
    system "make", "install", "DESTDIR=#{prefix}"
  end
end
