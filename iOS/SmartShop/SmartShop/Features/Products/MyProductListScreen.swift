import SwiftUI

struct MyProductListScreen: View {
  @State private var isPresented = false
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Add Product") {
            isPresented = true
          }
        }
      }
      .sheet(isPresented: $isPresented) {
        NavigationStack {
          AddProductView()
        }
      }
  }
}

#Preview {
  NavigationStack {
    MyProductListScreen()
  }
}
