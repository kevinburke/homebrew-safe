class Envdir < Formula
  desc "CLI tool for loading/editing environment variables"
  homepage "https://github.com/kevinburke/envdir"
  url "https://github.com/kevinburke/envdir/archive/v0.7.tar.gz"
  sha256 "b573d3cb1057b0fff0c33cb1afb070325fbc71f5661095d6862c3a27e40bcffa"
  license "MIT"
  head "https://github.com/kevinburke/envdir.git", branch: "main"

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    srcpath = buildpath/"src/github.com/kevinburke/envdir"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", *std_go_args()
    end
  end
end
