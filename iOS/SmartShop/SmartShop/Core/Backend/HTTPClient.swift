import Foundation

// MARK: HTTP Methods

enum HTTPMethod {
  case get([URLQueryItem])
  case post(Data?)
  case put(Data?)
  case delete
  case patch(Data?)

  var name: String {
    switch self {
    case .get:
      "GET"
    case .post:
      "POST"
    case .put:
      "PUT"
    case .delete:
      "DELETE"
    case .patch:
      "PATCH"
    }
  }
}

struct Resource<T: Codable> {
  let url: URL
  let method: HTTPMethod
  var headers: [String: String]? = nil
  var modelType: T.Type

  init(
    url: URL,
    method: HTTPMethod = .get([]),
    headers: [String: String]? = nil,
    modelType: T.Type)
  {
    self.url = url
    self.method = method
    self.headers = headers
    self.modelType = modelType
  }
}

// MARK: HTTP Client process

protocol HTTPClientProtocol {
  func load<T: Codable>(_ resource: Resource<T>) async throws -> T
}

class HTTPClient: HTTPClientProtocol {
  private let session: URLSession

  init() {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
    configuration.httpCookieAcceptPolicy = .never
    session = URLSession(configuration: configuration)
    URLCache.shared.removeAllCachedResponses()
  }

  func load<T>(_ resource: Resource<T>) async throws -> T where T: Decodable, T: Encodable {
    var request = URLRequest(url: resource.url)

    switch resource.method {
    case .get(let queryItems):
      var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
      components?.queryItems = queryItems
      guard let url = components?.url else {
        throw NetworkError.badRequest
      }
      request.url = url

    case .post(let data), .put(let data):
      request.httpMethod = resource.method.name
      request.httpBody = data

    case .delete:
      request.httpMethod = resource.method.name

    case .patch(let data):
      request.httpMethod = "PATCH"
      request.httpBody = data
    }

    if let headers = resource.headers {
      for (key, value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }

    switch httpResponse.statusCode {
    case 200 ..< 299:
      break
    default:
//      let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
//      throw NetworkError.errorResponse(errorResponse)

      if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
        throw NetworkError.errorResponse(errorResponse)
      } else {
        // If decoding fails, create a default ErrorResponse with the status code.
        let error = ErrorResponse(message: "HTTP Error: \(httpResponse.statusCode)")
        throw NetworkError.errorResponse(error)
      }
    }

    do {
      let result = try JSONDecoder().decode(resource.modelType, from: data)
      return result
    } catch {
      throw NetworkError.decodingError(error)
    }
  }
}

extension HTTPClient {
  static var development: HTTPClient {
    HTTPClient()
  }
}
