import SwiftUI

// TODO: Add error message below invalid textfields!

struct ProfileView: View {
  @AppStorage("userId") var userId: String?
  @Environment(CartStore.self) private var cartStore
  @Environment(UserStore.self) private var userStore

  // Editable fields
  @State private var name: String = ""
  @State private var lastName: String = ""
  @State private var street: String = ""
  @State private var city: String = ""
  @State private var stateText: String = ""
  @State private var zip: String = ""
  @State private var country: String = ""

  // Indicates if any update is pending or in progress.
  @State private var updatingUserInfo: Bool = false

  var body: some View {
    Form {
      Section(header: Text("Personal Information").font(.headline)) {
        TextField("First Name", text: $name)
        TextField("Last Name", text: $lastName)
      }

      Section(header: Text("Address").font(.headline)) {
        TextField("Street", text: $street)
        TextField("City", text: $city)
        TextField("State", text: $stateText)
        TextField("Zip Code", text: $zip)
        TextField("Country", text: $country)
      }

      Section {
        Button(role: .destructive) {
          signOut()
        } label: {
          HStack {
            Spacer()
            Text("Sign Out")
              .font(.headline)
            Spacer()
          }
        }
      }
    }
    .navigationTitle("Profile")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save") {
          Task {
            await updateUserInfo() // remove it from the UI
          }
        }
        .disabled(!isFormValid)
      }
    }
    .task {
      await loadUserInfo()
    }
  }

  private func loadUserInfo() async {
    do {
      try await userStore.loadUserInfo()
      guard let user = userStore.user else { return }
      name = user.name
      lastName = user.lastName
      street = user.street
      city = user.city
      stateText = user.state
      country = user.country
      zip = user.zipCode

    } catch {
      print("Error loading user info: \(error.localizedDescription)")
    }
  }

  private func updateUserInfo() async {
    do {
      // create UserInfo
      let userInfo = UserInfo(name: name, lastName: lastName, street: street, city: city, state: stateText, country: country, zipCode: zip)
      try await userStore.UpdateUserInfo(userInfo)
    } catch {
      print("Error updating user info: \(error.localizedDescription)")
    }
  }

  private var isFormValid: Bool {
    !name.isEmpty && !lastName.isEmpty && !city.isEmpty && zip.isZipCode && !country.isEmpty
  }

  // sign out action: Remove token, clear user data, and empty cart
  private func signOut() {
    let _ = Keychain<String>.delete("jwttoken")
    userId = nil
    cartStore.emptyCart()
  }
}

#Preview {
  NavigationStack {
    ProfileView()
      .environment(CartStore(httpClient: .development))
      .environment(UserStore(httpClient: .development))
  }
}
