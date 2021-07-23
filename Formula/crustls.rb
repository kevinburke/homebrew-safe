class Crustls < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/v0.7.2.tar.gz"
  sha256 "68ad936fdd2a71416e7bea5d16fd400af806d6c01c0d3c0a6ff75b197eb5c883"
  head "https://github.com/abetterinternet/crustls.git", :branch => "main"

  depends_on "rust" => :build

  def install
    ENV.append "PROFILE", "release"
    system "make"
    system "make", "install", "DESTDIR=#{prefix}"
  end
end
