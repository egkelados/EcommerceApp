import SwiftUI

struct ProductCellView: View {
  let product: Product
  let action: (() -> Void)?

  init(product: Product, action: (() -> Void)? = nil) {
    self.product = product
    self.action = action
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      AsyncImage(url: product.photoURL) { img in
        img.resizable()
          .clipShape(RoundedRectangle(cornerRadius: 11))
          .scaledToFit()

      } placeholder: {
        ProgressView()
      }

      Text(product.name)
        .fontDesign(.rounded)
      Text(product.description)
        .fontDesign(.rounded)

      HStack {
        Text("Price:")
          .fontDesign(.rounded)

        Text(String(format: "$%.2f", product.price))
          .fontDesign(.rounded)
      }
    }
    .padding()
    .onTapGesture {
      self.action?()
    }
  }
}

#Preview {
  ProductCellView(product: Product.preview)
}
