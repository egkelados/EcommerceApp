import Foundation

protocol Endpoint {
  var url: URL { get }
  var path: String { get }
}

enum CoreEndpoint: Endpoint {
  var url: URL {
    return URL(string: path, relativeTo: AppConfiguration.baseURL)!
  }

  case login
  case register

  var path: String {
    switch self {
    case .login:
      return "login"
    case .register:
      return "register"
    }
  }
}
