class Buildkite < Formula
  desc "Buildkite CLI tool"
  homepage "https://github.com/kevinburke/buildkite"
  url "https://github.com/kevinburke/buildkite/archive/v0.18.tar.gz"
  sha256 "c83e352a129a66815f33aa9a6a25fe1f5f7ed5055343538974c1a7e63fb6c620"
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
