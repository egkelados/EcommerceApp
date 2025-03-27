import SwiftUI

struct MyProductListScreen: View {
  @Environment(ProductStore.self) private var productStore
  @State private var isPresented = false

  @AppStorage("userId") private var userId: Int?

  private func loadMyProducts() async {
    do {
      guard let userId = userId else {
        throw UserError.missingId
      }
      try await productStore.loadMyProduct(by: userId)
    } catch {
      print(error.localizedDescription)
    }
  }

  var body: some View {
    List(productStore.myProducts) { product in
      Text(product.name)
    }
    .task {
      await loadMyProducts()
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Add Product") {
          isPresented = true
        }
      }
    }
    .sheet(isPresented: $isPresented) {
      NavigationStack {
        AddProductView()
      }
    }
  }
}

#Preview {
  NavigationStack {
    MyProductListScreen()
      .environment(ProductStore(httpClient: .development))
  }
}
