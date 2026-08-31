class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  # `url` goes below this comment when the `stable` block is removed.
  url "https://curl.se/download/curl-8.21.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_21_0/curl-8.21.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.21.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.21.0.tar.bz2"
  sha256 "ad6f2f94934b38e31e48272833c99b891d045b4565fe942a53fbd27bd3910e16"
  license "curl"

  livecheck do
    url "https://curl.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "rust" => :build
    depends_on "kevinburke/safe/rustls-ffi"
  end

  keg_only :provided_by_macos

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "kevinburke/safe/rustls-ffi"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "openldap"
  depends_on "perl"
  depends_on "zstd"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    # inreplace "configure.ac", "capi/include", "include"
    # inreplace "configure.ac", "target/debug", "lib"
    system "autoreconf", "-fi"

    # https://github.com/abetterinternet/crustls/wiki/Building-curl-with-crustls-and-Hyper
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-ca-path
      --with-brotli=#{formula_opt_prefix("brotli")}
      --with-libidn2
      --without-libpsl
      --with-nghttp2=#{formula_opt_prefix("libnghttp2")}
      --with-zstd=#{formula_opt_prefix("zstd")}
      --with-zsh-functions-dir=#{zsh_completion}
      --with-fish-functions-dir=#{fish_completion}
      --with-rustls=#{formula_opt_prefix("kevinburke/safe/rustls-ffi")}
      --with-default-ssl-backend=rustls
    ]

    args << if OS.mac?
      "--with-gssapi"
    else
      "--with-gssapi=#{formula_opt_prefix("krb5")}"
    end

    system "./configure", *args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "scripts/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    curl_features = shell_output("#{bin}/curl-config --features").split("\n")
    %w[HTTP2 brotli zstd].each do |feature|
      assert_includes curl_features, feature
    end

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_path_exists testpath/"test.pem"
    assert_path_exists testpath/"certdata.txt"
  end
end
