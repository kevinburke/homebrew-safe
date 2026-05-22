class GithubActions < Formula
  desc "CLI tool for working with GitHub Actions"
  homepage "https://github.com/kevinburke/github-actions"
  url "https://github.com/kevinburke/github-actions/archive/v0.7.0.tar.gz"
  sha256 "bb80fbd93d321d423d40e40ef2c7c756b7230e220c0d15a0321079ed776b9ad0"
  license "MIT"
  head "https://github.com/kevinburke/github-actions.git", branch: "main"

  depends_on "go"

  def install
    system "go", "build", *std_go_args()
  end

  test do
    assert_match "github-actions version #{version.to_s}", shell_output("#{bin}/github-actions version")
  end
end
