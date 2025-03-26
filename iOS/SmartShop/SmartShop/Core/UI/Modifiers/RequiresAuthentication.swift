import Foundation
import SwiftUI

struct RequiresAuthentication: ViewModifier {
  @State private var isLoading: Bool = true

  @AppStorage("userId") var userId: String?

  func body(content: Content) -> some View {
    Group {
      if isLoading {
        ProgressView("Loading....")
      } else {
        if userId != nil {
          content
        } else {
          LoginView()
        }
      }
    }.onAppear(perform: checkAuthentication)
  }

  private func checkAuthentication() {
    guard let token = Keychain<String>.get("jwttoken"), JWTTokenValidator.validate(token: token) // Check it also on the backend
    else {
      userId = nil
      isLoading = false
      return
    }

    isLoading = false
  }
}

public extension View {
  func requiresAuthentication() -> some View {
    modifier(RequiresAuthentication())
  }
}
