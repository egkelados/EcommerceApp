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

// MARK: Generic resource for the request

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
  private let logger: LoggerProtocol

  init(logger: LoggerProtocol = Logger()) {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
    configuration.httpCookieAcceptPolicy = .never
    session = URLSession(configuration: configuration)
    URLCache.shared.removeAllCachedResponses()
    self.logger = logger
  }

  func load<T>(_ resource: Resource<T>) async throws -> T where T: Decodable, T: Encodable {
    var request = URLRequest(url: resource.url)

    var headers: [String: String] = resource.headers ?? [:]

    if let token = Keychain<String>.get("jwttoken") {
      headers["Authorization"] = "Bearer \(token)"
    }

    // add headers to the request
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key)
    }

    switch resource.method {
    case .get(let queryItems):
      if !queryItems.isEmpty {
        var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        guard let url = components?.url else {
          throw NetworkError.badRequest
        }
        request.url = url
      }

    case .post(let data), .put(let data):
      request.httpMethod = resource.method.name
      request.httpBody = data

    case .delete:
      request.httpMethod = resource.method.name

    case .patch(let data):
      request.httpMethod = "PATCH"
      request.httpBody = data
    }

    let requestID = randomRequestIdentifier()
    logger.info("INFO: Starting \(request.httpMethod ?? "UNKNOWN") request for \(request.url?.absoluteString ?? "unknown URL")")

    let (data, response) = try await session.data(for: request)

    // Log raw JSON response.
    if let rawJSON = String(data: data, encoding: .utf8) {
      logger.info("INFO: <req_id: \(requestID)> Got response with status code \((response as? HTTPURLResponse)?.statusCode ?? -1) and \(data.count) bytes of data")
      logger.debug("DEBUG: Raw JSON Response:\n \(rawJSON)")
    } else {
      logger.error("ERROR: <req_id: \(requestID)> Unable to convert data to String.")
    }

    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }

    switch httpResponse.statusCode {
    case 200 ..< 299:
      break
    default:
      if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
        logger.error("ERROR: HTTP error: <req_id: \(requestID)> \(httpResponse.statusCode) - \(errorResponse.message ?? "")")

        throw NetworkError.errorResponse(errorResponse)
      } else {
        let error = ErrorResponse(message: "HTTP Error: <req_id: \(requestID)> \(httpResponse.statusCode)")
        logger.error("ERROR: HTTP error: <req_id: \(requestID)> \(httpResponse.statusCode)")

        throw NetworkError.errorResponse(error)
      }
    }

    do {
      let result = try JSONDecoder().decode(resource.modelType, from: data)
      logger.info("INFO: Successfully decoded response into \(resource.modelType)")
      return result
    } catch {
      logger.error("ERROR: <req_id: \(requestID)> Decoding error: \(error.localizedDescription)")
      throw NetworkError.decodingError(error)
    }
  }

  /// Generates a random request identifier for logging.
  private func randomRequestIdentifier() -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0 ..< 8).map { _ in letters.randomElement()! })
  }
}

extension HTTPClient {
  static var development: HTTPClient {
    HTTPClient()
  }
}
