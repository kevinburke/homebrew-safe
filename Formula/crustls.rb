class Crustls < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/abetterinternet/crustls"
  url "https://github.com/abetterinternet/crustls/archive/v0.4.0.tar.gz"
  sha256 "6d30b06096750c52c718d70d0bc8259d6e3716aecc267d5bb0b8635e314f87e8"
  head "https://github.com/abetterinternet/crustls.git", :branch => "main"

  depends_on "rust" => :build

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}"
  end
end
