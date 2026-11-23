class Nightporter < Formula
  desc "Handles your PRs while you're away: an agentic night shift for GitHub and GitLab"
  homepage "https://night-porter.com"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/night-porter/nightporter/releases/download/v0.7.0/nightporter-aarch64-apple-darwin.tar.xz"
      sha256 "bb0c7f7a9aa066ac1a64d1ab6f3249a68c58e916fb1c1262066f3c331eb9a429"
    end
    if Hardware::CPU.intel?
      url "https://github.com/night-porter/nightporter/releases/download/v0.7.0/nightporter-x86_64-apple-darwin.tar.xz"
      sha256 "34a39e039f72c01e191e8f94033070407f2f595961aa08a5f2cb3d3d1fd430cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/night-porter/nightporter/releases/download/v0.7.0/nightporter-aarch64-unknown-linux-musl.tar.xz"
      sha256 "fb8adcd73258eb57515695393ce85120812641c41d64f6790fc0dc34a10ebf83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/night-porter/nightporter/releases/download/v0.7.0/nightporter-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ec7021517314581740d6a5435cac5caa22db95dfb2e2f6dfb23602de0569c344"
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
