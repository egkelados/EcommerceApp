import Foundation

extension UserDefaults {
  enum UserDefaultsKeys: String {
    case userId
  }

  var userId: Int? {
    get {
      object(forKey: UserDefaultsKeys.userId.rawValue) as? Int
//      let id = integer(forKey: UserDefaultsKeys.userId.rawValue)
//      return id == 0 ? nil : id
    }
    set {
      set(newValue, forKey: UserDefaultsKeys.userId.rawValue)
    }
  }
}
