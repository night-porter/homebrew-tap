class Nightporter < Formula
  desc "Handles your PRs while you're away: an agentic night shift for GitHub and GitLab"
  homepage "https://night-porter.com"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/night-porter/nightporter/releases/download/v0.6.0/nightporter-aarch64-apple-darwin.tar.xz"
      sha256 "e8b63a07cbd20e48251c30c76409e6eeba59253b7666008f257db0ca742b9fed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/night-porter/nightporter/releases/download/v0.6.0/nightporter-x86_64-apple-darwin.tar.xz"
      sha256 "a61871112a05fcb79c465cfccec94a567679e89db699168d9d9b696678388f71"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/night-porter/nightporter/releases/download/v0.6.0/nightporter-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6d40a4bee0cbf1f9458367633f7c4867540408879bb97f2956eb472fae490228"
    end
    if Hardware::CPU.intel?
      url "https://github.com/night-porter/nightporter/releases/download/v0.6.0/nightporter-x86_64-unknown-linux-musl.tar.xz"
      sha256 "46d6fcbdac0c1e9af2ba6656417704afba49915df97ffd095b63b672fdea773c"
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
