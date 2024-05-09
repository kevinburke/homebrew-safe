class RustlsFfi < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.13.0.tar.gz"
  sha256 "462d9069d655d433249d3d554ad5b5146a6c96c13d0f002934bd274ce6634854"
  head "https://github.com/rustls/rustls-ffi.git", :branch => "main"

  depends_on "rust" => :build

  def install
    # https://github.com/rustls/rustls-ffi/issues/113
    ENV.append "PROFILE", "release"
    system "make"
    system "make", "install", "DESTDIR=#{prefix}"
  end
end
