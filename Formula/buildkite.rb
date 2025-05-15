class Buildkite < Formula
  desc "Buildkite CLI tool"
  homepage "https://github.com/kevinburke/buildkite"
  url "https://github.com/kevinburke/buildkite/archive/v0.17.tar.gz"
  sha256 "31f169561f737ba49c33d9d6846b8338c5959f904be02e38a1b3eb10bfb82a4f"
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
