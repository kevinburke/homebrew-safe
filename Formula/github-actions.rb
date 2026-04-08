class GithubActions < Formula
  desc "CLI tool for working with GitHub Actions"
  homepage "https://github.com/kevinburke/github-actions"
  url "https://github.com/kevinburke/github-actions/archive/v0.6.1.tar.gz"
  sha256 "dbc1faad4ee70b3a2de9f399fe97573dc584bffef4cbe729eefbdf12148d4996"
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
