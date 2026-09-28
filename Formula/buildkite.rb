class Buildkite < Formula
  desc "CLI tool for working with Buildkite"
  homepage "https://github.com/kevinburke/buildkite"
  url "https://github.com/kevinburke/buildkite/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "c58c9cf08eb1300c4437ad3e54e379f5ebfc22be4b1437605e8d8768658af47d"
  license "MIT"
  head "https://github.com/kevinburke/buildkite.git", branch: "main"

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    srcpath = buildpath/"src/github.com/kevinburke/buildkite"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", *std_go_args
    end
  end

  test do
    assert_match "buildkite version #{version}", shell_output("#{bin}/buildkite version")
  end
end
