cask "tip-app" do
  version "1.6.1"
  sha256 "e85f2f631c2547fdd39a961e0193d03c73f8a50e1f0a3b4607960fe7a88a7a6d"

  url "https://github.com/monkey-trader/trading-intelligence-platform/releases/download/v#{version}/tip-app_#{version}_darwin_universal.zip"
  name "Trading Intelligence Platform"
  desc "Mac-App für das Trading-Journal mit BingX-Import (Fenster auf tip-server)"
  homepage "https://github.com/monkey-trader/trading-intelligence-platform"

  depends_on formula: "monkey-trader/tap/tip-server"
  depends_on macos: ">= :big_sur"

  app "Trading Intelligence Platform.app"

  # Die App ist nur ad-hoc signiert (keine Apple-Developer-ID). Ohne diesen Schritt blockiert Gatekeeper den Start.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Trading Intelligence Platform.app"]
  end

  # Nur Fenster-Einstellungen; die Datenbank (journal.db) bleibt bewusst erhalten.
  zap trash: "~/Library/Application Support/tip/window.json"

  caveats <<~EOS
    Die App ist nur ein Fenster auf den Dienst tip-server. Der Dienst muss laufen:
      brew services start tip-server
    BingX-Keys (nur Lese-Rechte) stehen in ~/.config/tip/env, siehe README.
  EOS
end
