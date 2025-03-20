//
//  AddItemView.swift
//  Project-Calculator
//
// 
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var products: [Product]
    @Binding var categories: [String]
    let saveAction: () -> Void
    
    @State private var name = ""
    @State private var price = ""
    @State private var selectedCategory = "Food"
    @State private var newCategory = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Name", text: $name)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    
                    Picker("category", selection: $selectedCategory){
                        ForEach(categories, id: \.self){category in Text(category)
                        }
                    }
                    TextField("New Category", text:$newCategory)
                    Button("Add Category"){
                        if !newCategory.isEmpty && !categories.contains(newCategory){
                            categories.append(newCategory)
                            selectedCategory = newCategory
                            newCategory = ""
                        }
                    }
                        }
                    }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let priceValue = Double(price), !name.isEmpty {
                            let newItem = Product(name: name, price: priceValue, category: selectedCategory)
                            products.append(newItem)
                            saveAction()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddItemView(products: .constant([]), categories: .constant(["Food","Medication","Cleaning","Other"]), saveAction:{})
}

