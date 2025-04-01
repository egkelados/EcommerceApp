import SwiftUI

struct MyProductDetailScreen: View {
  @State private var product: Product
  @Environment(\.dismiss) private var dismiss
  @Environment(ProductStore.self) private var productStore
  @State private var isPresented = false

  init(product: Product) {
    self._product = State(initialValue: product)
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
        Menu {
          Button(role: .destructive) {
            Task { await deleteProduct() }
          } label: {
            Label("Delete", systemImage: "trash")
          }
          
          Button {
            isPresented = true
          } label: {
            Label("Edit", systemImage: "square.and.pencil")
          }
        } label: {
          Image(systemName: "ellipsis.circle")
        }
      }
    }
    .sheet(isPresented: $isPresented) {
      NavigationStack {
        AddProductView(product: product)
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
