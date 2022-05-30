class Buildkite < Formula
  desc "Buildkite CLI tool"
  homepage "https://github.com/kevinburke/buildkite"
  url "https://github.com/kevinburke/buildkite/archive/v0.10.tar.gz"
  sha256 "d207c1adc7b753d75f580b19ad35a55a4741cd2205b264ab8fcc0a7a98d41fa4"
  license "MIT"
  head "https://github.com/kevinburke/buildkite.git", branch: "master"

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
