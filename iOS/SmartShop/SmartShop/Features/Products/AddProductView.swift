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

      let product = Product(name: name, description: description, price: price, photoURL: downloadURL, userId: userId)

      try await productStore.saveProduct(product)
      dismiss()

    } catch {
      print(error.localizedDescription)
    }
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
        Button("Save") {
          Task {
            await saveProduct()
          }
        }
        .disabled(!isFormValid)
      }
    }
  }
}

#Preview {
  NavigationStack {
    AddProductView()
  }
  .environment(ProductStore(httpClient: .development))
}
