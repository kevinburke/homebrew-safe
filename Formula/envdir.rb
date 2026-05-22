class Envdir < Formula
  desc "CLI tool for loading/editing environment variables"
  homepage "https://github.com/kevinburke/envdir"
  url "https://github.com/kevinburke/envdir/archive/v0.8.2.tar.gz"
  sha256 "cd9ad545cc8fb4c7b104e480f402728914fc9f19b33a0276d216b23ff24efc2d"
  license "MIT"
  head "https://github.com/kevinburke/envdir.git", branch: "main"

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    srcpath = buildpath/"src/github.com/kevinburke/envdir"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", *std_go_args()
    end
  end

  test do
    (testpath/"env").mkpath
    (testpath/"env"/"GREETING").write("hello world\n")
    output = shell_output("#{bin}/envdir #{testpath}/env /usr/bin/env")
    assert_match "GREETING=hello world", output
  end
end
