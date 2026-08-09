# Homebrew cask for CunAI. Lives in the public tap repo
# (github.com/CanPixel/homebrew-tap, path Casks/cunai.rb); CI's
# publish-homebrew.py stamps version/hashes and pushes it there on release.
# Install: brew install --cask CanPixel/tap/cunai
cask "cunai" do
  version "1.0.9"

  # Both arches ship: the macOS CI job builds natively for Apple Silicon and
  # cross-compiles the Intel dmg. publish-homebrew.py stamps both hashes from
  # SHA256SUMS.txt, matching on the _aarch64.dmg / _x64.dmg suffixes.
  on_arm do
    sha256 "7222245d466d8ed618642ef01a64ad95733f7e6c219b2b8d6b61001c1f19d40a"

    url "https://artifacts.cunai.app/releases/v#{version}/CunAI_#{version}_aarch64.dmg"
  end
  on_intel do
    sha256 "3639bdde0f1445f68af1b21c097bd4c1e25cd451a164978b0ab97b75743828bc"

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
