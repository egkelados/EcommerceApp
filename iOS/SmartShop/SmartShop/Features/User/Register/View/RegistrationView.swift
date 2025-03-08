import SwiftUI

struct RegistrationView: View {
  @Environment(\.authenticationController) var authenticationController
  @Environment(\.dismiss) var dismiss
  @State var username: String = ""
  @State var password: String = ""
  @State private var message: String = ""
  @State private var isErrorMessage: Bool = false

  var isFormValid: Bool {
    !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
  }

  func register() async {
    do {
      let response = try await authenticationController.register(username: username, password: password)
      print("Registered user: \(response)")
      if response.success {
        dismiss()
      } else {
        message = response.message ?? ""
        isErrorMessage = true
      }
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

      Button("Register") {
        Task {
          await register()
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
    RegistrationView()
  }.environment(\.authenticationController, .development)
}
