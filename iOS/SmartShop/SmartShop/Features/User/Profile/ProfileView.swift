import SwiftUI

struct ProfileView: View {
  @AppStorage("userId") var userId: String?

  var body: some View {
    Button("Signout") {
      let _ = Keychain<String>.delete("jwttoken")
    }
  }
}

#Preview {
  ProfileView()
}
