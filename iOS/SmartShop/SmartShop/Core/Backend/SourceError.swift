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
      return NSLocalizedString("Bad Request (400): Unable to perform the request", comment: "badRequestError")
    case .decodingError(let error):
      return NSLocalizedString("Unable to decode successful response: \(error)", comment: "decodingError")
    case .invalidResponse:
      return NSLocalizedString("Invalid server response", comment: "invalidResponseError")
    case .errorResponse(let error):
      if let errorResponse = error as? ErrorResponse,
         let message = errorResponse.message
      { return message }
      return NSLocalizedString("Server returned an error: \(error)", comment: "ErrorResponse")
    }
  }
}
