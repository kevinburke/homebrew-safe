class Buildkite < Formula
  desc "Buildkite CLI tool"
  homepage "https://github.com/kevinburke/buildkite"
  url "https://github.com/kevinburke/buildkite/archive/v0.26.tar.gz"
  sha256 "31ccfc8c18f0a592ec6891c42d212915feb3772f2e77575cc3c2efa69a91ab70"
  license "MIT"
  head "https://github.com/kevinburke/buildkite.git", branch: "main"

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    srcpath = buildpath/"src/github.com/kevinburke/buildkite"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", *std_go_args()
    end
  end

  test do
    assert_match "buildkite version #{version.to_s}", shell_output("#{bin}/buildkite version")
  end
end
