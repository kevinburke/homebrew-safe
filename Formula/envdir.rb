class Envdir < Formula
  desc "CLI tool for loading/editing environment variables"
  homepage "https://github.com/kevinburke/envdir"
  url "https://github.com/kevinburke/envdir/archive/v0.2.tar.gz"
  sha256 "8980038a021a9636b39d74e9795317f8852a788d16a5314ba4415e191b316f43"
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
