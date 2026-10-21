cask "trading-intelligence-app" do
  version "1.6.3"
  sha256 "4717b421274f646436133430eb085829772e10d73ba4e2cbfd14d8b3f3c67214"

  url "https://github.com/monkey-trader/trading-intelligence-platform/releases/download/v#{version}/trading-intelligence-app_#{version}_darwin_universal.zip"
  name "Trading Intelligence"
  desc "Mac-App für das Trading-Journal mit BingX-Import (Fenster auf trading-intelligence)"
  homepage "https://github.com/monkey-trader/trading-intelligence-platform"

  depends_on formula: "monkey-trader/tap/trading-intelligence"
  depends_on macos: :big_sur

  app "Trading Intelligence.app"

  # Die App ist nur ad-hoc signiert (keine Apple-Developer-ID). Ohne diesen Schritt blockiert Gatekeeper den Start.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Trading Intelligence.app"]
  end

  # Nur Fenster-Einstellungen; die Datenbank (journal.db) bleibt bewusst erhalten.
  zap trash: "~/Library/Application Support/tip/window.json"

  caveats <<~EOS
    Die App ist nur ein Fenster auf den Dienst trading-intelligence. Der Dienst muss laufen:
      brew services start trading-intelligence
    BingX-Keys (nur Lese-Rechte) stehen in ~/.config/tip/env, siehe README.
  EOS
end
