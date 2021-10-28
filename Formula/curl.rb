class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.79.1.tar.bz2"
  sha256 "de62c4ab9a9316393962e8b94777a570bb9f71feb580fb4475e412f2f9387851"
  license "curl"

  livecheck do
    url "https://curl.haxx.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "rust" => :build
    depends_on "kevinburke/safe/rustls-ffi"
    depends_on "kevinburke/safe/hyper"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "libidn2"
  depends_on "libssh2"
  depends_on "openldap"
  depends_on "rtmpdump"
  depends_on "zstd"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    system "autoreconf -fi" if build.head?

    # https://github.com/abetterinternet/crustls/wiki/Building-curl-with-crustls-and-Hyper
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-ca-path
      --with-gssapi
      --with-libidn2
      --with-librtmp
      --without-libpsl
      --without-nghttp2
      --without-metalink
      --without-ssl
      --enable-debug
      --with-hyper=#{Formula["kevinburke/safe/hyper"].opt_prefix}
      --with-rustls=#{Formula["kevinburke/safe/rustls-ffi"].opt_prefix}
      --with-default-ssl-backend=rustls
    ]
    # --without-ca-bundle

    on_macos do
      args << "--with-gssapi"
      ENV.append "CPPFLAGS", "-framework Security"
    end

    on_linux do
      args << "--with-gssapi=#{Formula["krb5"].opt_prefix}"
    end

    system "./configure", *args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
