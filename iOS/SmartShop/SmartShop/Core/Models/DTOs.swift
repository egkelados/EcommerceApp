import Foundation

// place all the models inside here and refactor the rest...

struct Product: Codable, Identifiable, Hashable {
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

struct UploadDataResponse: Codable {
  let message: String?
  let success: Bool
  let downloadURL: URL?

  private enum CodingKeys: String, CodingKey {
    case message, success
    case downloadURL = "url"
  }
}

struct DeleteProductResponse: Codable {
  let success: Bool
  let message: String?
}

extension Product {
  static var preview: Product {
    Product(id: 26, name: "Luxury chair", description: "This is one fantastic chair that will make you feel like a king or queen of the world ! It is made of the finest materials and has a design that is sure to turn heads.", price: 252.0, photoURL: URL(string: "http://localhost:8080/api/uploads/image-1744100466846.png"), userId: 26)
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

struct UpdateProductResponse: Codable {
  let success: Bool
  let product: Product?
  let message: String?
}

struct Cart: Codable {
  var id: Int?
  let userId: Int
  var cartItems: [CartItem] = []

  private enum CodingKeys: String, CodingKey {
    case id, cartItems
    case userId = "user_id"
  }

  var total: Double {
    cartItems.reduce(0) { total, cartItem in
      total + Double(cartItem.quantity) * cartItem.product.price
    }
  }

  var itemCount: Int {
    return cartItems.reduce(0) { total, cartItem in
      total + cartItem.quantity
    }
  }
}

struct CartItem: Codable, Identifiable {
  let id: Int?
  let product: Product
  var quantity: Int = 1
}

struct AddToCartResponse: Codable {
  let success: Bool
  let cartItem: CartItem?
  let message: String?
}

struct CartResponse: Codable {
  let success: Bool
  let cart: Cart?
  let message: String?
}

extension Cart {
  static var preview: Cart {
    return Cart(id: 1, userId: 99, cartItems: [
      CartItem(id: 12, product: Product(
        id: 20,
        name: "Testing for chair",
        description: "This preview is for testing purposes.",
        price: 3999.0,
        photoURL: URL(string: "https://picsum.photos/200/300"),
        userId: 22
      ), quantity: 2),
      CartItem(id: 12, product: Product(
        id: 27,
        name: "Wallpaper",
        description: "Wallapaper for your home and office.",
        price: 3999.0,
        photoURL: URL(string: "https://picsum.photos/200/300"),
        userId: 22
      ), quantity: 2),
      CartItem(id: 12, product: Product(
        id: 27,
        name: "Superman",
        description: "Fantastic design for your home.",
        price: 3999.0,
        photoURL: URL(string: "https://picsum.photos/200/300"),
        userId: 22
      ), quantity: 2),
      CartItem(id: 12, product: Product(
        id: 20,
        name: "Another one product",
        description: "This is a whatever you want.",
        price: 3999.0,
        photoURL: URL(string: "https://picsum.photos/200/300"),
        userId: 22
      ), quantity: 2),
      CartItem(id: 12, product: Product(
        id: 27,
        name: "Wow image preview",
        description: "Random Image for testing",
        price: 3999.0,
        photoURL: URL(string: "https://picsum.photos/200/300"),
        userId: 22
      ), quantity: 2)
    ])
  }
}

struct UserInfo: Codable {
//  let id: Int?
  let name: String
  let lastName: String
  let street: String
  let city: String
  let state: String
  let country: String
  let zipCode: String

  private enum CodingKeys: String, CodingKey {
    case name = "first_name"
    case lastName = "last_name"
    case zipCode = "zip_code"
    case street, city, state, country
  }
}

struct UserInfoResponse: Codable {
  let success: Bool
  let user: UserInfo?
  let message: String?
}

extension UserInfo {
  func encode() -> Data? {
    try? JSONEncoder().encode(self)
  }
}

struct OrderItem: Codable, Hashable, Identifiable {
  var id: Int?
  let product: Product
  var quantity: Int = 1

  init(from cartItem: CartItem) {
    self.id = nil
    self.product = cartItem.product
    self.quantity = cartItem.quantity
  }
}

struct Order: Codable, Hashable, Identifiable {
  var id: Int?
  let userId: Int
  let total: Double
  let items: [OrderItem]

  init(from cart: Cart) {
    self.id = nil
    self.userId = cart.userId
    self.total = cart.total
    self.items = cart.cartItems.map(OrderItem.init)
  }

  private enum CodingKeys: String, CodingKey {
    case id, total, items
    case userId = "user_id"
  }

  func toRequestBody() -> [String: Any] {
    return [
      "total": total,
      "order_items": items.map { item in
        [
          "product_id": item.product.id,
          "quantity": item.quantity
        ]
      }
    ]
  }
}
