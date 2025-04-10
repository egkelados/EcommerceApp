import SwiftUI

@main
struct SmartShopApp: App {
  @State private var productStore = ProductStore(httpClient: HTTPClient())
  @State private var cartStore = CartStore(httpClient: HTTPClient())
  @State private var userStore = UserStore(httpClient: HTTPClient())

  @AppStorage("userId") private var userId: String?

  private func loadUserAndCart() async {
    do {
      try await cartStore.loadCart()
      try await userStore.loadUserInfo()

    } catch {
      print(error.localizedDescription)
    }
  }

  var body: some Scene {
    WindowGroup {
      SmartShopTabView()
        .environment(\.authenticationController, .development)
        .environment(productStore)
        .environment(cartStore)
        .environment(userStore)
        .environment(\.uploader, ImageUploader(httpClient: HTTPClient()))
        .task(id: userId) {
          if userId != nil {
            await loadUserAndCart()
          }
        }
    }
  }
}
