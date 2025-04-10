import Foundation

extension String {
  var isEmptyOrWhitespace: Bool {
    return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var isZipCode: Bool {
    let zipCodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
    return NSPredicate(format: "SELF MATCHES %@", zipCodeRegex).evaluate(with: self)
  }
}
