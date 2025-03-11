import SwiftUI

struct LoginView: View {
  @Environment(\.authenticationController) var authenticationController
  @Environment(\.dismiss) var dismiss
  @State var username: String = ""
  @State var password: String = ""
  @State private var message: String = ""
  @State private var isErrorMessage: Bool = false

  var isFormValid: Bool {
    !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
  }

  func login() async {
    do {
     
    } catch {
      isErrorMessage = true
      message = error.localizedDescription
    }

    username = ""
    password = ""
  }

  var body: some View {
    Form {
      TextField("Username", text: $username)
        .textInputAutocapitalization(.never)

      SecureField("Password", text: $password)

      Button("Login") {
        Task {
          await login()
        }
      }
      .disabled(!isFormValid)
    }
    .alert("Error", isPresented: $isErrorMessage, actions: {
      Button("OK", role: .cancel) {
        isErrorMessage = false
      }
    }, message: {
      Text(message)
    })
  }
}

#Preview {
  NavigationStack {
    LoginView()
  }.environment(\.authenticationController, .development)
}
