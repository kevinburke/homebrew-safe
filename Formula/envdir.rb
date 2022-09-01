class Envdir < Formula
  desc "CLI tool for loading/editing environment variables"
  homepage "https://github.com/kevinburke/envdir"
  url "https://github.com/kevinburke/envdir/archive/v0.5.tar.gz"
  sha256 "3e11777a63ca0fbf41038f5da0e3034b553ab3c78d8c998678c1fba195c24782"
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
