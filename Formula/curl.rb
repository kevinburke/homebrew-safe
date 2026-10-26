class Curl < Formula
  MINIMUM_BROTLI_VERSION = "1.2.1".freeze

  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  # `url` goes below this comment when the `stable` block is removed.
  url "https://curl.se/download/curl-8.23.0.tar.bz2"
  mirror "https://github.com/curl/curl/releases/download/curl-8_23_0/curl-8.23.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/curl-8.23.0.tar.bz2"
  mirror "http://fresh-center.net/linux/www/legacy/curl-8.23.0.tar.bz2"
  sha256 "95b22eb32bf6d1fa6e3e9463bdb61cece3efc56d86576a9b3cbd428246a6d854"
  license "curl"
  revision 1

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
  depends_on "libidn2"
  depends_on "libssh2"
  depends_on "openldap"
  depends_on "perl"
  depends_on "rtmpdump"
  depends_on "zstd"
  depends_on "kevinburke/safe/rustls-ffi"

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    # CVE-2026-111497: check the installed decoder, not the available formula.
    brotli_pc = Formula["brotli"].opt_lib/"pkgconfig/libbrotlidec.pc"
    brotli_version = Utils.safe_popen_read("pkg-config", "--modversion", brotli_pc.to_s).strip
    unless brotli_version.match?(/\A\d+\.\d+\.\d+\z/) &&
           Version.new(brotli_version) >= Version.new(MINIMUM_BROTLI_VERSION)
      odie "Brotli >= #{MINIMUM_BROTLI_VERSION} is required; run `brew update && brew upgrade brotli`."
    end

    # inreplace "configure.ac", "capi/include", "include"
    # inreplace "configure.ac", "target/debug", "lib"
    system "autoreconf", "-fi"

    # https://github.com/abetterinternet/crustls/wiki/Building-curl-with-crustls-and-Hyper
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-ca-path
      --with-brotli=#{Formula["brotli"].opt_prefix}
      --with-libidn2
      --with-librtmp
      --without-libpsl
      --without-nghttp2
      --without-metalink
      --without-secure-transport
      --with-zsh-functions-dir=#{zsh_completion}
      --with-fish-functions-dir=#{fish_completion}
      --with-rustls=#{Formula["kevinburke/safe/rustls-ffi"].opt_prefix}
      --with-default-ssl-backend=rustls
    ]

    args << if OS.mac?
      "--with-gssapi"
    else
      "--with-gssapi=#{Formula["krb5"].opt_prefix}"
    end

    system "./configure", *args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "scripts/mk-ca-bundle.pl"
  end

  test do
    output = shell_output("#{bin}/curl --version")
    brotli_version = output[/\bbrotli\/(\d+\.\d+\.\d+)\b/, 1]
    assert brotli_version, "curl must report the loaded Brotli decoder version: #{output}"
    assert_operator Version.new(brotli_version), :>=, Version.new(MINIMUM_BROTLI_VERSION)

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
