class RustlsFfi < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.8.0.tar.gz"
  sha256 "438159d436c63f0de1b9d830a74d92997e9fb545403e4ea8742a371cb2dfafbd"
  head "https://github.com/rustls/rustls-ffi.git", :branch => "main"

  depends_on "rust" => :build

  def install
    # https://github.com/rustls/rustls-ffi/issues/113
    ENV.append "PROFILE", "release"
    system "make"
    system "make", "install", "DESTDIR=#{prefix}"
  end
end
