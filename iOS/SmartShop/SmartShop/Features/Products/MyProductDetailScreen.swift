import SwiftUI

struct MyProductDetailScreen: View {
  private let product: Product
  @Environment(\.dismiss) private var dismiss
  @Environment(ProductStore.self) private var productStore
  init(product: Product) {
    self.product = product
  }

  private func deleteProduct() async {
    do {
      try await productStore.deleteProduct(product)
      dismiss()
    } catch {
      print(error.localizedDescription)
    }
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      AsyncImage(url: product.photoURL) { image in
        image
          .resizable()
          .clipShape(RoundedRectangle(cornerRadius: 22))
          .scaledToFit()
      } placeholder: {
        ProgressView()
      }
      .padding()

      VStack(alignment: .leading, spacing: 10) {
        Text(product.name)
          .font(.title)

        Text("Description:").bold()
          .underline()

        Text(product.description)

        Spacer()

        HStack {
          Text("Price: ")

          Text(product.price, format: .currency(code: "USD"))
          Spacer()
        }
        .font(.title3.bold())
      }
      .padding()
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(role: .destructive) {
          Task {
            await deleteProduct()
          }

        } label: {
          Image(systemName: "trash")
            .foregroundStyle(.red)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    MyProductDetailScreen(product: Product.preview)
      .environment(ProductStore(httpClient: .development))
  }
}
