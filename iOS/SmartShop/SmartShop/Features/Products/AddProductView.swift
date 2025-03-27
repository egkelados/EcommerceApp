import SwiftUI

struct AddProductView: View {
  @State private var name: String = ""
  @State private var description: String = ""
  @State private var price: Double?

  @Environment(ProductStore.self) private var productStore
  @Environment(\.dismiss) private var dismiss
  @AppStorage("userId") private var userId: Int?

  private var isFormValid: Bool {
    !name.isEmpty && !description.isEmpty && (price ?? 0) > 0
  }

  private func saveProduct() async {
    do {
      guard let userId = userId else {
        throw ProductSaveError.missingUserId
      }
      guard let price = price else {
        throw ProductSaveError.invalidPrice
      }
      let product = Product(name: name, description: description, price: price, photoURL: URL(string: "http://localhost:8080/api/uploads/chair1.png"), userId: userId)

      try await productStore.saveProduct(product)
      dismiss()

    } catch {
      print(error.localizedDescription)
    }
  }

  var body: some View {
    Form {
      TextField("Enter name", text: $name)
      TextField("Enter description", text: $description, axis: .vertical)
        .lineLimit(5, reservesSpace: true)
      TextField("Enter price", value: $price, format: .number)
    }.toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save") {
          Task {
            await saveProduct()
          }
        }
        .disabled(!isFormValid)
      }
    }
  }
}

#Preview {
  NavigationStack {
    AddProductView()
  }
  .environment(ProductStore(httpClient: .development))
}
