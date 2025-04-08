import SwiftUI

struct CartScreen: View {
  @Environment(CartStore.self) private var cartStore

  var body: some View {
    List {
      if let cart = cartStore.cart {
        HStack {
          Text("Total: ")
            .font(.title)
            .fontDesign(.rounded)
          Text(cartStore.total, format: .currency(code: "USD"))
            .font(.title).bold()
        }

        Button {} label: {
          Text("Proceed to checkout ^[(\(cartStore.itemCount) Item](inflect: true))")
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .background(.green)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.borderless)

        CartItemListView(cartItems: cart.cartItems)

      } else {
        ContentUnavailableView("No items in cart", systemImage: "cart")
      }
    }
    .task {
      try? await cartStore.loadCart()
    }
  }
}

#Preview {
  NavigationStack {
    CartScreen()
      .environment(CartStore(httpClient: .development))
  }
}

struct CartItemListView: View {
  let cartItems: [CartItem]

  var body: some View {
    ForEach(cartItems) { cartItem in
      CartItemView(cartItem: cartItem)
    }
  }
}

#Preview {
  CartItemListView(cartItems: Cart.preview.cartItems)
}

struct CartItemView: View {
  let cartItem: CartItem

  var body: some View {
    HStack(alignment: .top, spacing: 20) {
      AsyncImage(url: cartItem.product.photoURL) { img in
        img.resizable()
          .clipShape(RoundedRectangle(cornerRadius: 11))
          .scaledToFit()
          .frame(width: 104, height: 104)

      } placeholder: {
        ProgressView()
      }

      VStack(alignment: .leading) {
        Text(cartItem.product.name)
        Text("\(cartItem.quantity) x \(cartItem.product.price, format: .currency(code: "USD"))")
      }
      
      Spacer()
    }
  }
}

#Preview {
  CartItemView(cartItem: Cart.preview.cartItems.first!)
}
