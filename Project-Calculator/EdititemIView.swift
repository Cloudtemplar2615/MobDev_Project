//
//  EditItemView.swift
//  Project-Calculator
//

import SwiftUI

struct EditItemView: View {
    @Binding var product: Product
    @Binding var isEditing: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Product")) {
                    TextField("Product Name", text: $product.name)
                    TextField("Price", value: $product.price, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Picker("Category", selection: $product.category) {
                        Text("Food").tag("Food")
                        Text("Medication").tag("Medication")
                        Text("Cleaning").tag("Cleaning")
                        Text("Other").tag("Other")
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        isEditing = false
                    }
                }
            }
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(product: .constant(Product(name: "Example", price: 5.99, category: "Food")), isEditing: .constant(true))
    }
}
