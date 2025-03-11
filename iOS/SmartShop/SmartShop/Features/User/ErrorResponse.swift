import Foundation

struct ErrorResponse: Codable, Error {
  let message: String?
}
