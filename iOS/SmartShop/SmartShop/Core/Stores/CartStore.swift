import Foundation
import Observation

@Observable
class CartStore {
  let httpClient: HTTPClient
  var cart: Cart?

  init(httpClient: HTTPClient) {
    self.httpClient = httpClient
  }

  var total: Double {
    cart?.cartItems.reduce(0.0) { total, cartItem in
      total + (cartItem.product.price * Double(cartItem.quantity))
    } ?? 00
  }

  var itemCount: Int {
    cart?.cartItems.reduce(0) { total, cartItem in
      total + cartItem.quantity
    } ?? 0
  }

  @MainActor
  func loadCart() async throws {
    let resource = Resource(url: CoreEndpoint.loadCart.url, modelType: CartResponse.self)

    let response = try await httpClient.load(resource)
    if let cart = response.cart, response.success {
      self.cart = cart
    } else {
      throw CartError.operationFailed(response.message ?? "Failed to load cart")
    }
  }

  @MainActor
  func updateItemQuantity(productId: Int, quantity: Int) async throws {
    try await addCartItem(productId: productId, quantity: quantity)
  }

  @MainActor
  func addCartItem(productId: Int, quantity: Int) async throws {
    let body = ["productId": productId, "quantity": quantity]
    let bodyData = try JSONEncoder().encode(body)

    let resource = Resource(url: CoreEndpoint.addCartItem.url, method: .post(bodyData), modelType: AddToCartResponse.self)

    let response = try await httpClient.load(resource)
    if let cartItem = response.cartItem, response.success {
      // initialize the cart if it is nil
      if cart == nil {
        guard let userId = UserDefaults.standard.userId else {
          throw UserError.missingId
        }
        cart = Cart(userId: userId)
      }
      // if item already in cart then update it
      if let index = cart?.cartItems.firstIndex(where: { $0.id == cartItem.id }) {
        cart?.cartItems[index] = cartItem
      } else {
        // add the new cart item
        cart?.cartItems.append(cartItem)
      }

    } else {
      // the item is not even here
      throw CartError.operationFailed(response.message ?? "Unknown error from the server")
    }
  }

  func deleteCartItem(id: Int) async throws {
    let resource = Resource(url: CoreEndpoint.delete(id).url, method: .delete, modelType: DeleteCartItemResponse.self)
    let response = try await httpClient.load(resource)
    if response.success {
      if let cart = cart {
        self.cart?.cartItems = cart.cartItems.filter{ $0.id != id }
      }
      print("Deleted")
    } else {
      throw CartError.operationFailed(response.message ?? "Unable to delete the item")
    }
  }
}

struct DeleteCartItemResponse: Codable {
  let success: Bool
  let message: String?
}
