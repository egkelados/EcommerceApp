import Foundation
import Observation

@Observable
class ProductStore {
  private(set) var products: [Product] = []
  let httpClient: HTTPClient

  init(httpClient: HTTPClient) {
    self.httpClient = httpClient
  }

  @MainActor
  func loadAllProducts() async throws {
    let resource = Resource(url: CoreEndpoint.products.url, modelType: [Product].self)
//    let resource = Resource(url: URL(string: "http://localhost:8080/api/products")!, modelType: [Product].self)

    products = try await httpClient.load(resource)
  }
}
