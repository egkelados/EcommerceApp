import SwiftUI

struct ProfileView: View {
  @AppStorage("userId") var userId: String?
  @Environment(CartStore.self) private var cartStore

  var body: some View {
    Button("Signout") {
      let _ = Keychain<String>.delete("jwttoken")
      userId = nil
      cartStore.emptyCart()
    }
  }
}

#Preview {
  ProfileView()
    .environment(CartStore(httpClient: .development))
}
