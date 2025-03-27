import Foundation

// place all the models inside here and refactor the rest...

struct Product: Codable, Identifiable {
  var id: Int?
  let name: String
  let description: String
  let price: Double
  let photoURL: URL?
  let userId: Int

  private enum CodingKeys: String, CodingKey {
    case id, name, description, price
    case photoURL = "photo_url"
    case userId = "user_id"
  }
}

extension Product {
  static var preview: Product {
    Product(id: 1, name: "Luxury chair", description: "This is one fantastic chair that will make you feel like a king or queen of the world ! It is made of the finest materials and has a design that is sure to turn heads.", price: 252.0, photoURL: URL(string: "http://localhost:8080/api/uploads/chair1.png"), userId: 5)
  }

  func encode() -> Data? {
    try? JSONEncoder().encode(self)
  }
}

struct CreateProductResponse: Codable {
  let success: Bool
  let product: Product?
  let message: String?
}
