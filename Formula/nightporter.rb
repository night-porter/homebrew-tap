class Nightporter < Formula
  desc "Handles your PRs while you're away: an agentic night shift for GitHub and GitLab"
  homepage "https://night-porter.com"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/night-porter/nightporter/releases/download/v0.3.0/nightporter-aarch64-apple-darwin.tar.xz"
      sha256 "a2287ff93fadeea09a5034f6e235e728141bb9482ffa9d70b3c7f0ca0964b344"
    end
    if Hardware::CPU.intel?
      url "https://github.com/night-porter/nightporter/releases/download/v0.3.0/nightporter-x86_64-apple-darwin.tar.xz"
      sha256 "5004c1ba727afc790b3a9431b3a8bd0e07e143cf98d30b06dd946c654b0c8f5d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/night-porter/nightporter/releases/download/v0.3.0/nightporter-aarch64-unknown-linux-musl.tar.xz"
      sha256 "2ccba1ba2114b7cde24e1e18b641462289ccfe23057f4392c07bed5d359e6909"
    end
    if Hardware::CPU.intel?
      url "https://github.com/night-porter/nightporter/releases/download/v0.3.0/nightporter-x86_64-unknown-linux-musl.tar.xz"
      sha256 "0c7d7c7b8ea3d80058b4875cbfe2304be81c3d6b98398072f62a47c89551ace6"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "nightporter"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "nightporter"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "nightporter"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "nightporter"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nightporter --version")
  end
end
