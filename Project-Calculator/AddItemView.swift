//
//  AddItemView.swift
//  Project-Calculator
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode: Binding <PresentationMode>
    @Binding var products: [Product]
    @Binding var categories: [String]
    var saveAction: () -> Void

    @State private var name = ""
    @State private var price = ""
    @State private var category = "Food"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Name", text: $name)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)

                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let priceValue = Double(price) {
                            let newProduct = Product(name: name, price: priceValue, category: category)
                            products.append(newProduct)
                            saveAction()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .background(Color(.systemBackground)) // Supports Dark Mode
        }
    }
}
