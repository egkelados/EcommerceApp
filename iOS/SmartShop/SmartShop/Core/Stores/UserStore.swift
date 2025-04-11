import Foundation
import Observation

@Observable
class UserStore {
  var user: UserInfo?
  private let httpClient: HTTPClientProtocol

  init(httpClient: HTTPClientProtocol = HTTPClient()) {
    self.httpClient = httpClient
  }

  @MainActor
  func loadUserInfo() async throws {
    let resource = Resource(url: CoreEndpoint.loadUserInfo.url, modelType: UserInfoResponse.self)

    let response = try await httpClient.load(resource)

    if response.success, let userInfo = response.user {
      user = userInfo
    }else {
      throw UserError.operationFailed(response.message ?? "Unable to load user info")
    }
  }

  @MainActor
  func UpdateUserInfo(_ userInfo: UserInfo) async throws {
    let resource = Resource(url: CoreEndpoint.updateUserInfo.url, method: .put(userInfo.encode()), modelType: UserInfoResponse.self)

    let response = try await httpClient.load(resource)

    if response.success, let userInfo = response.user {
      user = userInfo
    } else {
      throw UserError.operationFailed(response.message ?? "Unable to update user info")
    }
  }
}
