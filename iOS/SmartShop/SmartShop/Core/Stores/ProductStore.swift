import Foundation
import Observation

@Observable
class ProductStore {
  private(set) var products: [Product] = []
  private(set) var myProducts: [Product] = []
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

  func saveProduct(_ product: Product) async throws {
    let resource = Resource(url: CoreEndpoint.products.url, method: HTTPMethod.post(product.encode()), modelType: CreateProductResponse.self)
    let response = try await httpClient.load(resource)
    if let product = response.product, response.success {
      myProducts.append(product)
    } else {
      throw ProductSaveError.operationFailed(response.message ?? "")
    }
  }
}
