class Nightporter < Formula
  desc "Handles your PRs while you're away: an agentic night shift for GitHub and GitLab"
  homepage "https://night-porter.com"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/night-porter/nightporter/releases/download/v0.4.0/nightporter-aarch64-apple-darwin.tar.xz"
      sha256 "9207ab67ecce9a4b0a6973fd4efedb1334f94328e4f20035f8f60afb1e228417"
    end
    if Hardware::CPU.intel?
      url "https://github.com/night-porter/nightporter/releases/download/v0.4.0/nightporter-x86_64-apple-darwin.tar.xz"
      sha256 "c3977924dfbff35ca3b6ac21a749833967a8a32a4a1b1a64a581cfdd6a4a69ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/night-porter/nightporter/releases/download/v0.4.0/nightporter-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5a7c6f1fac91ed080fb907bf5885a6cc7fdbbf12223273c2e47db41bf659d7c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/night-porter/nightporter/releases/download/v0.4.0/nightporter-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ac74c2810919f9cae6a282ddc2782ee6bb657bb543d5e1f1f17bc8da30a1bd27"
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
