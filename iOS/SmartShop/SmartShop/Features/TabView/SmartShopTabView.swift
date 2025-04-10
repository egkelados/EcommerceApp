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
      NavigationStack {
        ProductListScreen()
      }
    case .myProducts:
      NavigationStack {
        MyProductListScreen()
          .requiresAuthentication()
      }
    case .cart:
      CartScreen()
        .requiresAuthentication()
    case .profile:
      ProfileView()
        .requiresAuthentication()
    }
  }
}

struct SmartShopTabView: View {
  @Environment(CartStore.self) private var cartStore
  @State private var selection: AppScreen?
  var body: some View {
    TabView(selection: $selection) {
      ForEach(AppScreen.allCases) { screen in
        Tab(value: screen) {
          screen.destination
        } label: {
          screen.label
        }
        .badge(screen == .cart ? cartStore.cartQuantity : 0)
      }
    }
  }
}

#Preview {
  NavigationStack {
    SmartShopTabView()
  }
  .environment(ProductStore(httpClient: .development))
  .environment(CartStore(httpClient: .development))
}
