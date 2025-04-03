import Foundation
import Observation

@Observable
class CartStore {
  let httpCliend: HTTPClient
  var cart: Cart?

  init(httpCliend: HTTPClient) {
    self.httpCliend = httpCliend
  }

  @MainActor
  func addCartItem(productId: Int, quantity: Int) async throws {
    let body = ["productId": productId, "quantity": quantity]
    let bodyData = try JSONEncoder().encode(body)

    let resource = Resource(url: CoreEndpoint.addCartItem(productId).url, method: .post(bodyData), modelType: AddToCartResponse.self)

    let response = try await httpCliend.load(resource)
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
}
