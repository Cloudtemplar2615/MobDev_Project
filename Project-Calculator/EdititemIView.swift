//
//  EditItemView.swift
//  Project-Calculator
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var product: Product
    @Binding var products: [Product]
    var saveAction: () -> Void

    @State private var name: String
    @State private var price: String
    @State private var category: String

    init(product: Product, products: Binding<[Product]>, saveAction: @escaping () -> Void) {
        self._product = State(initialValue: product)
        self._products = products
        self.saveAction = saveAction
        self._name = State(initialValue: product.name)
        self._price = State(initialValue: "\(product.price)")
        self._category = State(initialValue: product.category)
    }

    let categories = ["Food", "Medication", "Cleaning", "Other"]

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
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let index = products.firstIndex(where: { $0.id == product.id }) {
                            products[index].name = name
                            products[index].price = Double(price) ?? product.price
                            products[index].category = category
                            saveAction()
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
