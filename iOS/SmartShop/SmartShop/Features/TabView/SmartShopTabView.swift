import SwiftUI

enum AppScreen: Hashable, Identifiable, CaseIterable {
  var id: AppScreen { self }

  case home
  case myProducts
  case cart
  case profile

  @ViewBuilder
  var label: some View {
    switch self {
    case .home:
      Label("Home", systemImage: "heart")
    case .myProducts:
      Label("My Products", systemImage: "star")
    case .cart:
      Label("Cart", systemImage: "cart")
    case .profile:
      Label("Profile", systemImage: "person.fill")
    }
  }

  @ViewBuilder
  var destination: some View {
    switch self {
    case .home:
      Text("Home")
    case .myProducts:
      Text("My Products")
        .requiresAuthentication()
    case .cart:
      Text("Cart")
        .requiresAuthentication()
    case .profile:
      ProfileView()
        .requiresAuthentication()
    }
  }
}

struct SmartShopTabView: View {
  @State private var selection: AppScreen?
  var body: some View {
    TabView(selection: $selection) {
      ForEach(AppScreen.allCases) { screen in
        Tab(value: screen) {
          screen.destination
        } label: {
          screen.label
        }
      }
    }
  }
}

#Preview {
  SmartShopTabView()
}
