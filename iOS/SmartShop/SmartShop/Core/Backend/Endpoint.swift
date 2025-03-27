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
    }
  }
}
