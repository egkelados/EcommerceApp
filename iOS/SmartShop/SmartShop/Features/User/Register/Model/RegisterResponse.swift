import Foundation

struct RegisterResponse: Codable {
  let email: String?
  let message: String?
  let success: Bool
}
