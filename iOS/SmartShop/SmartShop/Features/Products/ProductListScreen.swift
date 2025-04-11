import SwiftUI

struct ProductListScreen: View {
  @Environment(ProductStore.self) private var productStore
  @State private var selectedProduct: Product?
  var body: some View {
    List(productStore.products) { product in
      ProductCellView(product: product) {
        selectedProduct = product
      }
    }
    .navigationDestination(item: $selectedProduct) { product in
      ProductDetailScreen(product: product)
    }
    .task {
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
  }.environment(ProductStore(httpClient: HTTPClient.development))
    .environment(CartStore(httpClient: HTTPClient.development))
}
