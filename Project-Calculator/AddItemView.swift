//
//  AddItemView.swift
//  Project-Calculator
//Mustafa Bandukda - 101203879
//Jaeden Salandanan - 101324631
//Fredrich Tan -  101318950
//Hamzah Hafez - 101429091

import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var products: [Product]
    @Binding var categories: [String]
    var saveAction: () -> Void
    
    @State private var name = ""
    @State private var price = ""
    @State private var category = "Food"
    
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                        validateAndSave()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) { // just a done button to get rid of keyboard once user is done
                                    Spacer()
                                    Button("Done") {
                                        hideKeyboard()
                                    }
                                }
                            }
                .alert("Invalid Input", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(alertMessage)
                }
                .background(Color(.systemBackground)) // Supports Dark Mode
            }
        }
        
        
        func validateAndSave() {
            guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { // validation check prevention of empty inputs
                alertMessage = "Item name cannot be empty."
                showAlert = true
                return
            }
            
            
            
            guard let priceValue = Double(price), priceValue > 0 else { // validation check for price
                alertMessage = "Please enter a valid price greater than 0."
                showAlert = true
                return
            }
            
            let newProduct = Product(name: name, price: priceValue, category: category)
            products.append(newProduct)
            saveAction()
            presentationMode.wrappedValue.dismiss()
        }
        
        func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

