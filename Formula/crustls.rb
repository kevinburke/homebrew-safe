class Crustls < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/abetterinternet/crustls"
  head "https://github.com/abetterinternet/crustls.git", :branch => "main"

  depends_on "rust" => :build

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}"
  end
end
