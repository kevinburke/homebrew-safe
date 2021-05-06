class Crustls < Formula
  desc "C bindings for rustls"
  homepage "https://github.com/abetterinternet/crustls"
  url "https://github.com/abetterinternet/crustls/archive/v0.5.0.tar.gz"
  sha256 "53e89c54fd3d46942a9e5a26cdbb7828eecd5e20a447b1b64e40bcccbbdf4e82"
  head "https://github.com/abetterinternet/crustls.git", :branch => "main"

  depends_on "rust" => :build

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}"
  end
end
