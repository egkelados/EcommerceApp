import SwiftUI

@main
struct SmartShopApp: App {
  var body: some Scene {
    WindowGroup {
      SmartShopTabView()
        .environment(\.authenticationController, .development)
    }
  }
}
