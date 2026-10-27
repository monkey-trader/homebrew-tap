cask "trading-intelligence-app" do
  version "2.3.0"
  sha256 "b8b03efad0493da3ecc73157581f5f5d2c3748daa09617cad174bc2fcb81f7ec"

  url "https://github.com/monkey-trader/trading-intelligence-platform/releases/download/v#{version}/trading-intelligence-app_#{version}_darwin_universal.zip"
  name "Trading Intelligence"
  desc "Trading-Journal mit BingX-Import (Mac-App mit eingebautem Server)"
  homepage "https://github.com/monkey-trader/trading-intelligence-platform"

  depends_on macos: :big_sur

  app "Trading Intelligence.app"

  # Die App ist nur ad-hoc signiert (keine Apple-Developer-ID). Ohne diesen Schritt blockiert Gatekeeper den Start.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/Trading Intelligence.app"]
  end

  # Nur Fenster-Einstellungen; die Datenbank (journal.db) bleibt bewusst erhalten.
  zap trash: [
    "~/Library/Application Support/tip/server.log",
    "~/Library/Application Support/tip/window.json",
  ]

  caveats <<~EOS
    Die App startet ihren Server selbst; der Import läuft, solange die App offen ist.
    BingX-Keys (nur Lese-Rechte) stehen in ~/.config/tip/env:
      mkdir -p ~/.config/tip && chmod 700 ~/.config/tip
      printf 'BX_KEY=...\nBX_SECRET=...\n' > ~/.config/tip/env && chmod 600 ~/.config/tip/env
    Läuft schon der Brew-Dienst trading-intelligence, nutzt die App diesen.
  EOS
end
