class Hostsfile < Formula
  desc "CLI tool for editing /etc/hosts files"
  homepage "https://github.com/kevinburke/hostsfile"
  url "https://github.com/kevinburke/hostsfile/archive/1.6.tar.gz"
  sha256 "6b6ea8cceb8f6c2f6c8a6e33f78ad71b3020bc7a0b136bb40919fddc3d4dcb6a"
  license "MIT"
  head "https://github.com/kevinburke/hostsfile.git", branch: "master"

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    srcpath = buildpath/"src/github.com/kevinburke/hostsfile"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", *std_go_args()
    end
  end

  test do
    assert_match "hostsfile version #{version.to_s}", shell_output("#{bin}/hostsfile version")
  end
end
