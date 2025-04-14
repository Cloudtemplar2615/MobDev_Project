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
    @State private var showDeleteConfirmation = false

    
    @State private var showAlert = false
    @State private var alertMessage = ""

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
                        validateAndSave()
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .alert("Are you sure you want to delete this item?", isPresented: $showDeleteConfirmation) {
                        Button("Delete", role: .destructive) {
                            if let index = products.firstIndex(where: { $0.id == product.id }) {
                                products.remove(at: index)
                                saveAction()
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hideKeyboard()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
               
            .alert("Invalid Input", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    
    func validateAndSave() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            alertMessage = "Item name cannot be empty."
            showAlert = true
            return
        }

        guard let priceValue = Double(price), priceValue > 0 else {
            alertMessage = "Please enter a valid price greater than 0."
            showAlert = true
            return
        }

        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].name = trimmedName
            products[index].price = priceValue
            products[index].category = category
            saveAction()
        }
        presentationMode.wrappedValue.dismiss()
    }
}
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

