import SwiftUI

@main
struct SmartShopApp: App {
  @State private var productStore = ProductStore(httpClient: HTTPClient())
  @State private var cartStore = CartStore(httpCliend: HTTPClient())

  @AppStorage("userId") private var userId: String?

  var body: some Scene {
    WindowGroup {
      SmartShopTabView()
        .environment(\.authenticationController, .development)
        .environment(productStore)
        .environment(cartStore)
        .environment(\.uploader, ImageUploader(httpClient: HTTPClient()))
        .task(id: userId) {
          do {
            if userId != nil {
              try await cartStore.loadCart()
            }
          } catch {
            print(error.localizedDescription)
          }
        }
    }
  }
}
