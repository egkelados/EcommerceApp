import SwiftUI

struct MyProductListScreen: View {
  @Environment(ProductStore.self) private var productStore
  @State private var isPresented = false
  @State private var selectedProduct: Product?
  @AppStorage("userId") private var userId: Int?
  @State private var message: String?

  private func loadMyProducts() async {
    do {
      guard let userId = userId else {
        throw UserError.missingId
      }
      try await productStore.loadMyProduct(by: userId)
    } catch {
      message = error.localizedDescription
      print(error.localizedDescription)
    }
  }

  var body: some View {
    Group {
      if productStore.myProducts.isEmpty {
        ContentUnavailableView(
          label: {
            Label(message ?? "There are no products", systemImage: "star.fill")
          },
          description: {
            Text(message != nil ? "Failed to proceed with loading products. Please try again later or contact support." : "Add your first product")
          },
          actions: {
            Button("Add Product") {
              isPresented = true
            }
            .disabled(message != nil)
          }
        )
      } else {
        List(productStore.myProducts) { product in

          MyProductCellView(product: product) {
            selectedProduct = product
          }
        }
        .navigationDestination(item: $selectedProduct) { product in
          MyProductDetailScreen(product: product)
        }
        .listStyle(.plain)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button("Add Product") {
              isPresented = true
            }
          }
        }
      }
    }
    .task {
      await loadMyProducts()
    }
    .sheet(isPresented: $isPresented) {
      NavigationStack {
        AddProductView()
      }
    }
  }
}

struct MyProductCellView: View {
  private let product: Product
  private let action: (() -> Void)?

  init(
    product: Product,
    action: (() -> Void)? = nil
  ) {
    self.product = product
    self.action = action
  }

  var body: some View {
    HStack(alignment: .top) {
      AsyncImage(url: product.photoURL) { image in
        image
          .resizable()
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .frame(width: 100, height: 100)
      } placeholder: {
        ProgressView()
      }
      Spacer()

      VStack {
        Text(product.name)
          .font(.title3)
          .fontDesign(.rounded)
          .frame(maxWidth: .infinity, alignment: .leading)

        Text(product.price, format: .currency(code: "USD"))
          .font(.title3)
          .fontDesign(.rounded)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .onTapGesture {
      action?()
    }
  }
}

#Preview {
  NavigationStack {
    MyProductListScreen()
      .environment(ProductStore(httpClient: HTTPClient.development))
  }
}
