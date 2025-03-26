import SwiftUI

struct LoginView: View {
  @Environment(\.authenticationController) var authenticationController
  @Environment(\.dismiss) var dismiss
  @State var username: String = ""
  @State var password: String = ""
  @State private var message: String = ""
  @State private var isErrorMessage: Bool = false

  @AppStorage("userId") private var userId: Int?
  var isFormValid: Bool {
    !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
  }

  func login() async {
    isErrorMessage = false
    do {
      let response = try await authenticationController.login(username: username, password: password)
      print("Login response for user: \(response)")
      guard let token = response.token,
            let userId = response.userId,
            response.success
      else {
        message = response.message ?? "Internal server error. Request can not be completed."
        return
      }
      message = "Login successfull"
      print(token)
      // set the token in keychain
      Keychain.set(token, forKey: "jwttoken")

      // set userId in Userdefaults
      self.userId = userId

    } catch {
      message = error.localizedDescription
      print(message)
    }

    isErrorMessage = true
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
    .navigationTitle("Login")
    .alert("Error", isPresented: $isErrorMessage, actions: {
      Button("OK", role: .cancel) {
        isErrorMessage = false
      }
    }, message: {
      Text(message)
    }) // replace that with bottom message
  }
}

#Preview {
  NavigationStack {
    LoginView()
  }.environment(\.authenticationController, .development)
}
