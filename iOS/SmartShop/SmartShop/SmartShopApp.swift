import SwiftUI

@main
struct SmartShopApp: App {
  @State private var productStore = ProductStore(httpClient: HTTPClient())

  var body: some Scene {
    WindowGroup {
      SmartShopTabView()
        .environment(\.authenticationController, .development)
        .environment(productStore)
    }
  }
}
