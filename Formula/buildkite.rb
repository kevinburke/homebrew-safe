class Buildkite < Formula
  desc "Buildkite CLI tool"
  homepage "https://github.com/kevinburke/buildkite"
  url "https://github.com/kevinburke/buildkite/archive/v0.27.tar.gz"
  sha256 "f8b1df8ae870075da7b3098191764db599965a7c6706a08995c160c8dafea8da"
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
