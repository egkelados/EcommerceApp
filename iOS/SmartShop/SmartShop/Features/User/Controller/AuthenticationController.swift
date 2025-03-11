import Foundation
import SwiftUI

struct AuthenticationController {
  let httpClient: HTTPClient
  
  func register(username: String, password: String) async throws -> RegisterResponse{
    
    let body = ["username": username, "password": password]
    let bodyData = try JSONEncoder().encode(body)
    
    let resource = Resource(
      url: CoreEndpoint.register.url,
      method: HTTPMethod.post(bodyData),
      headers: body,
      modelType: RegisterResponse.self
    )
    
    let response = try await httpClient.load(resource)
    
    return response
  }
  
  func login(username: String, password: String) async throws -> LoginResponse
  {
    let body = ["username": username, "password": password]
    let bodyData = try JSONEncoder().encode(body)
    
    let resource = Resource(
      url: CoreEndpoint.login.url,
      method: HTTPMethod.post(bodyData),
      headers: body,
      modelType: LoginResponse.self
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
