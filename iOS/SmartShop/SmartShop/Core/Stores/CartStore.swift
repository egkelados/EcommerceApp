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
    
    if response.success {
      
    }else {
      
    }
  }
}
