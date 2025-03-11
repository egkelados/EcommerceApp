import Foundation

enum NetworkError: Error {
  case badRequest
  case decodingError(Error)
  case invalidResponse
  case errorResponse(Error)
}

extension NetworkError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .badRequest:
      NSLocalizedString("Bad Request (400): Unable to perform the request", comment: "badRequestError")
    case .decodingError(let error):
      NSLocalizedString("Unable to decode successful response: \(error)", comment: "decodingError")
    case .invalidResponse:
      NSLocalizedString("Invalid server response", comment: "invalidResponseError")
    case .errorResponse(let error):
      NSLocalizedString("Server returned an error: \(error)", comment: "ErrorResponse")
    }
  }
}
