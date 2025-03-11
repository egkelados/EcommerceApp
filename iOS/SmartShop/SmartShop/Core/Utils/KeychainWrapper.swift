import Foundation
import Security

struct Keychain<T: Codable> {
  static func set(_ value: T, forKey key: String) {
    do {
      let data = try JSONEncoder().encode(value)
      let query: [CFString: Any] = [
        kSecClass as CFString: kSecClassGenericPassword,
        kSecAttrAccount as CFString: key,
        kSecValueData as CFString: data
      ]
      
      SecItemDelete(query as CFDictionary) // delete existing data if any
      
      let status = SecItemAdd(query as CFDictionary, nil)
      if status != errSecSuccess {
        print("Error saving data to keychain: \(status)")
        return
      }
      
    } catch {
      print("Error saving data to keychain: \(error)")
    }
  }
  
  static func get(_ key: String) -> T? {
    do {
      let query: [CFString: Any] = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: key,
        kSecMatchLimit: kSecMatchLimitOne,
        kSecReturnData: true
      ]
      
      var item: CFTypeRef?
      let status = SecItemCopyMatching(query as CFDictionary, &item)
      
      if status == errSecSuccess,
         let data = item as? Data
      {
        do {
          let value = try JSONDecoder().decode(T.self, from: data)
          return value
        } catch {
          print("Error decoding data from keychain: \(error)")
        }
      }
      return nil
    }
  }
  
  static func delete(_ key: String) -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    return status == errSecSuccess
  }
}
