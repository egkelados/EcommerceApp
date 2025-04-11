import Foundation
import Observation

@Observable
class ProductStore {
  private(set) var products: [Product] = []
  private(set) var myProducts: [Product] = []
  let httpClient: HTTPClientProtocol

  init(httpClient: HTTPClientProtocol = HTTPClient()) {
    self.httpClient = httpClient
  }

  @MainActor
  func loadAllProducts() async throws {
    let resource = Resource(url: CoreEndpoint.products.url, modelType: [Product].self)
//    let resource = Resource(url: URL(string: "http://localhost:8080/api/products")!, modelType: [Product].self)

    products = try await httpClient.load(resource)
  }

  @MainActor
  func deleteProduct(_ product: Product) async throws {
    guard let productId = product.id else {
      throw ProductSaveError.productNotFound
    }

    let resource = Resource(url: CoreEndpoint.deleteProduct(productId).url, method: .delete, modelType: DeleteProductResponse.self)
    let response = try await httpClient.load(resource)

    if response.success {
      if let indexToDelete = myProducts.firstIndex(where: { $0.id == productId }) {
        myProducts.remove(at: indexToDelete)
      } else {
        throw ProductSaveError.operationFailed("Product not found in my products")
      }
    }
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

  func loadMyProduct(by userId: Int) async throws {
    let resource = Resource(url: CoreEndpoint.myProducts(userId).url, modelType: [Product].self)

    myProducts = try await httpClient.load(resource)
  }

  /// Update functino for the product
  func updateProduct(_ product: Product) async throws {
    guard let productId = product.id else {
      throw ProductSaveError.productNotFound
    }

    let resource = Resource(url: CoreEndpoint.updateProduct(productId).url, method: .put(product.encode()), modelType: UpdateProductResponse.self)
    let response = try await httpClient.load(resource)

    if let updatedProduct = response.product,!response.success {
      if let indexToUpdate = myProducts.firstIndex(where: { $0.id == productId }) {
        myProducts[indexToUpdate] = updatedProduct
      } else {
        throw ProductSaveError.productNotFound
      }
    } else {
      throw ProductSaveError.operationFailed(response.message ?? "Update product failed")
    }
  }
}
