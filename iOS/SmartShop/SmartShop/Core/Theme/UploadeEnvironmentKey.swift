import Foundation
import SwiftUI

extension EnvironmentValues {
  @Entry var uploader = ImageUploader(httpClient: HTTPClient())
}

/// refactor to one file in extensions........!!!!!

// MARK: This is prior to iOS 18

/*
 private struct UploaderEnvironmentKey: EnvironmentKey {
   static let defaultValue = ImageUploader(httpClient: HTTPClient())
 }

 extension EnvironmentValues {
   var uploader: ImageUploader {
     get {
       self[UploaderEnvironmentKey.self]
     } set {
       self[UploaderEnvironmentKey.self] = newValue
     }
   }
 }
 */
