import SwiftUI

enum QuantityChangeType: Equatable {
  case update(Int)
  case delete
}

struct CartItemQuantityView: View {
  @Environment(CartStore.self) private var cartStore
  let cartItem: CartItem
  @State private var quantity: Int = 0
  @State private var quantityChangeType: QuantityChangeType?

  var body: some View {
    HStack {
      Button {
        if quantity == 1 {
          quantityChangeType = .delete
        } else {
          quantity -= 1
          quantityChangeType = .update(-1)
        }
      } label: {
        Image(systemName: cartItem.quantity == 1 ? "trash" : "minus")
          .frame(width: 20, height: 20)
      }

      Text("\(cartItem.quantity)")

      Button {
        quantity += 1
        quantityChangeType = .update(1)
      } label: {
        Image(systemName: "plus")
      }
    }
    .frame(width: 150)
    .background(.gray)
    .foregroundStyle(.white)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .buttonStyle(.borderedProminent)
    .tint(.gray)
    .onAppear {
      quantity = cartItem.quantity
    }
    .task(id: quantityChangeType) {
      if let quantityChangeType {
        switch quantityChangeType {
        case .update(let change):
          do {
            guard let productId = cartItem.product.id else { return }
            try await cartStore.updateItemQuantity(productId: productId, quantity: change)
          } catch {
            print(error)
          }
        case .delete:
          do {
            guard let cartItemId = cartItem.id else { return }
            try await cartStore.deleteCartItem(id: cartItemId)
          } catch {
            print(error)
          }
        }
      }
      self.quantityChangeType = nil
    }
  }
}

#Preview {
  CartItemQuantityView(cartItem: Cart.preview.cartItems.first!)
    .environment(CartStore(httpClient: HTTPClient.development))
}
