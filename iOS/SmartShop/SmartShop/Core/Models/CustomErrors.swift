import Foundation

enum ProductSaveError: Error {
  case missingUserId
  case invalidPrice
  case operationFailed(String)
  case missingImage
}
