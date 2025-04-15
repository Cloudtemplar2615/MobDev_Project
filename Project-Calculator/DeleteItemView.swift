//
//  DeleteItemView.swift
//  Project-Calculator
//
//
//Mustafa Bandukda - 101203879
//Jaeden Salandanan - 101324631
//Fredrich Tan -  101318950
//Hamzah Hafez - 101429091

import SwiftUI

struct DeleteItemView: View {
    @Binding var product: Product
    @Binding var isEditing: Bool
    @Binding var products: [Product]  
    @State private var showingConfirmationDialog = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Delete Product")) {
                    Text("Are you sure you want to delete the product?")
                    Text("Name: \(product.name)")
                    Text("Price: \(product.price, format: .currency(code: "CAD"))")
                    Text("Category: \(product.category)")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Delete Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete") {
                        showingConfirmationDialog = true
                    }
                }
            }
            .confirmationDialog("Are you sure you want to delete this item?", isPresented: $showingConfirmationDialog, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    deleteProduct()
                }
                Button("Cancel", role: .cancel) {
                    showingConfirmationDialog = false
                }
            }
        }
    }

    private func deleteProduct() {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products.remove(at: index)
        }
        isEditing = false
    }
}

struct DeleteItemView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteItemView(
            product: .constant(Product(name: "Example", price: 5.99, category: "food")),
            isEditing: .constant(true),
            products: .constant([Product(name: "Example", price: 5.99, category: "food")])
        )
    }
}
