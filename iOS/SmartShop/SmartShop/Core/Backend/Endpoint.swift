import Foundation

protocol Endpoint: Equatable {
  var url: URL { get }
  var path: String { get }
}

enum CoreEndpoint: Endpoint {
  var url: URL {
    return URL(string: path, relativeTo: AppConfiguration.baseURL)!.absoluteURL
  }

  case login
  case register
  case products
  case myProducts(Int)
  case uploadProductImage
  case deleteProduct(Int)
  case updateProduct(Int)
  case addCartItem
  case loadCart
  case delete(Int)
  case updateUserInfo
  case loadUserInfo

  var path: String {
    switch self {
    case .login:
      return "auth/login"
    case .register:
      return "auth/register"
    case .products:
      return "products"
    case let .myProducts(userId):
      return "products/user/\(userId)"
    case .uploadProductImage:
      return "products/uploads"
    case let .deleteProduct(id):
      return "products/\(id)"
    case let .updateProduct(id):
      return "products/\(id)"
    case .addCartItem:
      return "cart/items"
    case .loadCart:
      return "cart/user"
    case let .delete(cartItemId):
      return "cart/item/\(cartItemId)"
    case .updateUserInfo:
      return "user"
    case .loadUserInfo:
      return "user"
    }
  }
}
