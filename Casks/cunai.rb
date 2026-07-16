# Homebrew cask for CunAI. Lives in the public tap repo
# (github.com/CanPixel/homebrew-tap, path Casks/cunai.rb); CI's
# publish-homebrew.py stamps version/hashes and pushes it there on release.
# Install: brew install --cask CanPixel/tap/cunai
cask "cunai" do
  version "1.0.5"

  # CI only builds an Apple Silicon dmg (the macOS job builds the runner's
  # native arch); reintroduce an on_intel block if x64 builds ever ship.
  on_arm do
    sha256 "e87ce9cb1a8dd0aa4a518cbdb565dcd35ae5419b569d5e3b1b08f6d33e611dad"
    url "https://artifacts.cunai.app/releases/v#{version}/CunAI_#{version}_aarch64.dmg"
  end

  name "CunAI"
  desc "Offline-first Sumerian dictionary with local semantic search"
  homepage "https://cunai.app/"

  depends_on arch: :arm64
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
