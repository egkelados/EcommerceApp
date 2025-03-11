import Foundation

struct LoginResponse: Codable {
  let userId: Int?
  let username: String?
  let success: Bool
  let message: String?
  let token: String?
}
