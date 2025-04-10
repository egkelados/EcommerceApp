import Foundation

enum ProductSaveError: Error {
  case missingUserId
  case invalidPrice
  case operationFailed(String)
  case missingImage
  case uploadFailed(String)
  case productNotFound
}

enum UserError: Error {
  case missingId
  case operationFailed(String)
}

enum CartError : Error {
  case operationFailed(String)
}
