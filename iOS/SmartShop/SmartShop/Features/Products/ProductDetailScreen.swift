import SwiftUI

struct ProductDetailScreen: View {
  @Environment(CartStore.self) private var cartStore
  let product: Product
  @State private var quantity: Int = 1

  var body: some View {
    ScrollView {
      AsyncImage(url: product.photoURL) { img in
        img
          .resizable()
          .scaledToFit()
      } placeholder: {
        ProgressView("Loading .. .. .. .")
      }
      .padding()

      VStack(alignment: .leading, spacing: 10) {
        Text(product.name)
          .font(.title)

        Text("Description:").bold()
          .underline()

        Text(product.description)

        HStack {
          Text("Price: ")

          Text(product.price, format: .currency(code: "USD"))
          Spacer()
        }
        .font(.title3.bold())
      }
      .padding()

      Stepper("Quantity: \(quantity)", value: $quantity)
        .padding(.horizontal)

      Button {
        Task {
          do {
            try await cartStore.addCartItem(productId: product.id!, quantity: quantity)
          } catch {
            print(error.localizedDescription)
          }
        }
      } label: {
        Text("Add to Cart")
      }
      .frame(maxWidth: .infinity)
      .frame(height: 40)
      .background(.blue)
      .foregroundStyle(.white)
      .clipShape(.capsule)
      .padding()
    }
    .scrollIndicators(.hidden)
    .scrollBounceBehavior(.automatic, axes: [.vertical])
  }
}

// TODO: create reusable bitton view
#Preview {
  ProductDetailScreen(product: Product.preview)
    .environment(CartStore(httpClient: HTTPClient.development))
}
