class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  url "https://curl.se/download/curl-7.83.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-7_82_0/curl-7.83.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-7.83.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-7.83.0.tar.bz2"
  sha256 "247c7ec7521c4258e65634e529270d214fe32969971cccb72845e7aa46831f96"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "rust" => :build
    depends_on "kevinburke/safe/rustls-ffi"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "libidn2"
  depends_on "libssh2"
  depends_on "openldap"
  depends_on "rtmpdump"
  depends_on "zstd"
  depends_on "kevinburke/safe/rustls-ffi"
  depends_on "kevinburke/safe/hyper"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    system "./buildconf" if build.head?

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

    cppflags = "-I#{Formula["kevinburke/safe/hyper"].opt_prefix}/include"
    on_macos do
      args << "--with-gssapi"
      cppflags += " -framework Security"
    end

    on_linux do
      args << "--with-gssapi=#{Formula["krb5"].opt_prefix}"
    end

    ENV.append "CPPFLAGS", cppflags
    ENV.append "LDFLAGS", "-L#{Formula["kevinburke/safe/hyper"].opt_prefix}/lib"

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
