class RustlsFfi < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.8.2.tar.gz"
  sha256 "aa627cdd1c8183b9c84e2360641dd8efc7412307aa5451b240058c41357d14fd"
  head "https://github.com/rustls/rustls-ffi.git", :branch => "main"

  depends_on "rust" => :build

  def install
    # https://github.com/rustls/rustls-ffi/issues/113
    ENV.append "PROFILE", "release"
    system "make"
    system "make", "install", "DESTDIR=#{prefix}"
  end
end
