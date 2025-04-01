import PhotosUI
import SwiftUI

struct AddProductView: View {
  @State private var name: String = ""
  @State private var description: String = ""
  @State private var price: Double?
  @State private var selectedImage: PhotosPickerItem?
  @State private var uiImage: UIImage?

  @Environment(\.uploader) private var uploader
  @Environment(ProductStore.self) private var productStore
  @Environment(\.dismiss) private var dismiss
  @AppStorage("userId") private var userId: Int?

  private let product: Product?
  init(product: Product? = nil) {
    self.product = product
  }

  private var isFormValid: Bool {
    !name.isEmpty && !description.isEmpty && (price ?? 0) > 0
  }

  private func saveProduct() async {
    do {
      guard let uiImage = uiImage, let imageData = uiImage.pngData() else {
        throw ProductSaveError.missingImage
      }

      let uploadDataResponse = try await uploader.upload(data: imageData)

      guard let downloadURL = uploadDataResponse.downloadURL, uploadDataResponse.success else {
        throw ProductSaveError.uploadFailed(uploadDataResponse.message ?? "")
      }

      print(downloadURL)

      guard let userId = userId else {
        throw ProductSaveError.missingUserId
      }
      guard let price = price else {
        throw ProductSaveError.invalidPrice
      }

      let product = Product(id: self.product?.id, name: name, description: description, price: price, photoURL: downloadURL, userId: userId)

      if self.product != nil {
        try await productStore.updateProduct(product)
      } else {
        try await productStore.saveProduct(product)
      }

      dismiss()

    } catch {
      print(error.localizedDescription)
    }
  }

  private var actionTitle: String {
    product != nil ? "Update" : "Add"
  }

  var body: some View {
    Form {
      TextField("Enter name", text: $name)
      TextField("Enter description", text: $description, axis: .vertical)
        .lineLimit(5, reservesSpace: true)
      TextField("Enter price", value: $price, format: .number)

      PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
        Image(systemName: "photo.on.rectangle")
      }

      if let uiImage {
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
    }
    .task {
      do {
        guard let product = product else { return }
        name = product.name
        description = product.description
        price = product.price

        if let phtotoURL = product.photoURL {
          guard let data = try await uploader.download(url: phtotoURL) else {
            return
          }
          uiImage = UIImage(data: data)
        }
      } catch {
        print(error.localizedDescription)
      }
    }
    .task(id: selectedImage) {
      if let selectedImage {
        do {
          if let data = try await selectedImage.loadTransferable(type: Data.self) {
            uiImage = UIImage(data: data)
          }
        } catch {
          print(error.localizedDescription)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(actionTitle) {
          Task {
            await saveProduct()
          }
        }
        .disabled(!isFormValid)
      }
    }
    .navigationTitle(actionTitle + " Product")
  }
}

#Preview {
  NavigationStack {
    AddProductView(product: Product.preview)
  }
  .environment(ProductStore(httpClient: .development))
}

#Preview {
  NavigationStack {
    AddProductView()
  }
  .environment(ProductStore(httpClient: .development))
}
