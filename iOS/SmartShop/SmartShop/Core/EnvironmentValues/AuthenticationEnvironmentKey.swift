import Foundation
import SwiftUI

extension EnvironmentValues {
  @Entry var authenticationController = AuthenticationController(httpClient: HTTPClient())
}

// MARK: This is prior to iOS 18

/*
 private struct AuthenticationEnvironmentKey: EnvironmentKey {
   static let defaultValue = AuthenticationController(httpClient: HTTPClient())
 }

 extension EnvironmentValues {
   var authenticationController: AuthenticationController {
     get {
       self[AuthenticationEnvironmentKey.self]
     } set {
       self[AuthenticationEnvironmentKey.self] = newValue
     }
   }
 }
 */
