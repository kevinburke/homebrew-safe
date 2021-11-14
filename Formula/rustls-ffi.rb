class RustlsFfi < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.8.1.tar.gz"
  sha256 "944b155f58acc657eea75c36f5bc96efa2c108c25ad104e91c51f14604e4e386"
  head "https://github.com/rustls/rustls-ffi.git", :branch => "main"

  depends_on "rust" => :build

  def install
    # https://github.com/rustls/rustls-ffi/issues/113
    ENV.append "PROFILE", "release"
    system "make"
    system "make", "install", "DESTDIR=#{prefix}"
  end
end
