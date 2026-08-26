# Homebrew cask for CunAI. Lives in the public tap repo
# (github.com/CanPixel/homebrew-tap, path Casks/cunai.rb); CI's
# publish-homebrew.py stamps version/hashes and pushes it there on release.
# Install: brew install --cask CanPixel/tap/cunai
cask "cunai" do
  version "1.2.0"

  # Both arches ship: the macOS CI job builds natively for Apple Silicon and
  # cross-compiles the Intel dmg. publish-homebrew.py stamps both hashes from
  # SHA256SUMS.txt, matching on the _aarch64.dmg / _x64.dmg suffixes.
  on_arm do
    sha256 "0a15d37760f92090fc21e02def4ba17711befb027409b071794a405f674c6cbe"

    url "https://artifacts.cunai.app/releases/v#{version}/CunAI_#{version}_aarch64.dmg"
  end
  on_intel do
    sha256 "8e22d1ff092f6625b5689e81de31f6f17d3c1dd8fae1cafa9b81e96de7b77864"

    url "https://artifacts.cunai.app/releases/v#{version}/CunAI_#{version}_x64.dmg"
  end

  name "CunAI"
  desc "Offline-first Sumerian dictionary with local semantic search"
  homepage "https://cunai.app/"

  # Same endpoint the website badge reads, so "what is current" has one
  # source of truth. Without a livecheck, `brew outdated --cask` can never
  # tell an installed user that a new CunAI exists.
  livecheck do
    url "https://artifacts.cunai.app/latest/latest-release.json"
    regex(/"version":\s*"v?(\d+(?:\.\d+)+)"/i)
  end

  depends_on macos: :big_sur

  app "CunAI.app"

  zap trash: [
    "~/Library/Application Support/com.canpixel.cunai",
    "~/Library/Caches/com.canpixel.cunai",
    "~/Library/Preferences/com.canpixel.cunai.plist",
    "~/Library/WebKit/com.canpixel.cunai",
  ]

  caveats <<~EOS
    CunAI is not notarized with Apple. If macOS reports the app as damaged,
    remove the quarantine attribute and launch again:
      xattr -cr /Applications/CunAI.app
  EOS
end
