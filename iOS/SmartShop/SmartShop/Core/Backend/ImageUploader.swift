import Foundation

enum MimeType: String {
  case png = "image/png"
  case jpg = "image/jpg"
  
  var value: String {
    return rawValue
  }
}

struct ImageUploader {
  let httpClient: HTTPClient
  
  func upload(data: Data, mimeType: MimeType = .png) async throws -> UploadDataResponse {
    let boundary = UUID().uuidString
    let headers = ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
    
    // create multipart form data body
    let body = createMultipartFormData(data: data, boundary: boundary)
    let resource = Resource(url: CoreEndpoint.uploadProductImage.url, method: .post(body), headers: headers, modelType: UploadDataResponse.self)
    let response = try await httpClient.load(resource)
    
    return response
  }
  
  private func createMultipartFormData(data: Data, mimeType: MimeType = .png, boundary: String) -> Data {
    var body = Data()
    let lineBreak = "\r\n"
    
    body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"upload.png\"\(lineBreak)".data(using: .utf8)!)
    body.append("Content-Type: \(mimeType.value)\(lineBreak)\(lineBreak)".data(using: .utf8)!)
    body.append(data)
    body.append(lineBreak.data(using: .utf8)!)
    
    // Add the closing boundary
    body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
    return body
  }
  
  func download(url: URL) async throws -> Data? {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
  }
}
