class Nightporter < Formula
  desc "Handles your PRs while you're away: an agentic night shift for GitHub and GitLab"
  homepage "https://night-porter.com"
  version "0.4.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/night-porter/nightporter/releases/download/v0.4.6/nightporter-aarch64-apple-darwin.tar.xz"
      sha256 "49d4426c7906619b09a7ee7ea488f9ff03026bcb1ba39dd171f4b078aa87918d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/night-porter/nightporter/releases/download/v0.4.6/nightporter-x86_64-apple-darwin.tar.xz"
      sha256 "8305ffda511fccad46e17473e778b50b6d871ed0273746199c47080700c2606a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/night-porter/nightporter/releases/download/v0.4.6/nightporter-aarch64-unknown-linux-musl.tar.xz"
      sha256 "768028a084908ee78a70f09f2b29bae4adcd3415eff2785f324e3f79de0bdc31"
    end
    if Hardware::CPU.intel?
      url "https://github.com/night-porter/nightporter/releases/download/v0.4.6/nightporter-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4191092660765706a668deb54ec05015880e3bd9a53f3e0bff218733f49b398d"
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
