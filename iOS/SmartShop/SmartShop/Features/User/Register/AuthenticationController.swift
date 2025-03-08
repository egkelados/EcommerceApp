import Foundation
import SwiftUI

struct AuthenticationController {
  let httpClient: HTTPClient
  
  func register(username: String, password: String) async throws -> RegisterModel{
    
    let body = ["username": username, "password": password]
    let bodyData = try JSONEncoder().encode(body)
    
    let resource = Resource(
      url: CoreEndpoint.register.url,
      method: HTTPMethod.post(bodyData),
      headers: body,
      modelType: RegisterModel.self
    )
    
    let response = try await httpClient.load(resource)
    
    return response
  }
}


extension AuthenticationController {
  static var development: AuthenticationController {
    AuthenticationController(httpClient: HTTPClient())
  }
}
