import Foundation

struct LoginResponse: Codable {
  let uerId: Int
  let username: String
  let success: Bool
  let message: String?
  let token: String?
}
