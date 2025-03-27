import SwiftUI

struct ProductListScreen: View {
  @Environment(ProductStore.self) private var productStore

  var body: some View {
    List(productStore.products) { product in
      ProductCellView(product: product)
    }.task {
      do {
        try await productStore.loadAllProducts()
      } catch {
        print("Error loading products: \(error.localizedDescription)")
      }
    }
  }
}

#Preview {
  NavigationStack {
    ProductListScreen()
  }.environment(ProductStore(httpClient: .development))
}
