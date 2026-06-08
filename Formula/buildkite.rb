class Buildkite < Formula
  desc "CLI tool for working with Buildkite"
  homepage "https://github.com/kevinburke/buildkite"
  url "https://github.com/kevinburke/buildkite/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "2fe0ab7cd42f85652c3b975429fbe6605dc622e70ac025b5910db6519157fa4c"
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
