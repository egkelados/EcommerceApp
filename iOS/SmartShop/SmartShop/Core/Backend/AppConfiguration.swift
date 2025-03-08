import Foundation

class AppConfiguration {
  static var baseURL: URL {
#if LOCAL
    return URL(string: "http://localhost:8080/api/auth/")!
    #else
    return URL(string: "http://localhost:8080/api/auth/")!
#endif
  }
}
