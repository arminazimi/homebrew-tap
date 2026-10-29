class Evergreen < Formula
  desc "Find evidence-backed deprecations and end-of-life dependencies"
  homepage "https://arminazimi.github.io/evergreen/"
  url "https://registry.npmjs.org/evergreen-deprecation/-/evergreen-deprecation-0.7.1.tgz"
  sha256 "3acc4fd1807eaab35e022f63c527f3693aa9de7d3bf05c58dec509ebf2bb9542"
  license "Apache-2.0"

  depends_on "node"

  def install
    ENV.prepend_path "PATH", formula_opt_bin("node")
    ENV["npm_config_cache"] = (buildpath/"npm-cache").to_s
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evergreen --version")
    assert_predicate bin/"evergreen-deprecation", :executable?
    assert_predicate bin/"evergreen-mcp", :executable?

    (testpath/"package.json").write <<~JSON
      {"private": true, "dependencies": {"request": "2.88.2"}}
    JSON
    (testpath/"client.js").write <<~JS
      const request = require("request");
      request.get("https://example.com");
    JS

    result = JSON.parse(shell_output("#{bin}/evergreen scan #{testpath} --json"))
    assert_equal "evergreen.scan.v1", result.fetch("schemaVersion")
    finding = result.fetch("findings").find { |item| item.fetch("ruleId") == "npm.package.request.deprecated" }
    refute_nil finding, "The installed package must include its lifecycle registry"
    assert finding.fetch("usages").any? { |usage| usage.fetch("location").fetch("path") == "client.js" },
           "The installed package must load its offline JavaScript parser and queries"
  end
end
