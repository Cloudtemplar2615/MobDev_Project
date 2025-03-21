//
//  ContentView.swift
//  Project-Calculator
//

import SwiftUI

struct Product: Identifiable, Codable {
    var id = UUID()
    var name: String
    var price: Double
    var category: String
}

struct ContentView: View {
    @State private var products: [Product] = []
    @State private var categories: [String] = ["Food", "Medication", "Cleaning", "Other"]
    @State private var showAddItemSheet = false
    @State private var showEditItemSheet = false
    @State private var selectedProduct: Product?
    @State private var showDeleteConfirmation = false
    @State private var indexToDelete: IndexSet?

    let taxRates: [String: Double] = [
        "Food": 0.05,
        "Medication": 0.00,
        "Cleaning": 0.13,
        "Other": 0.13
    ]

    var totalCost: Double {
        products.reduce(0) { total, product in
            let taxRate = taxRates[product.category] ?? 0.13
            return total + product.price + (product.price * taxRate)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(products) { product in
                        HStack {
                            Text(product.name)
                            Spacer()
                            Text("$\(product.price, specifier: "%.2f")")
                                .foregroundColor(.gray)
                        }
                        .onTapGesture {
                            selectedProduct = product
                            showEditItemSheet = true
                        }
                    }
                    .onDelete { indexSet in
                        indexToDelete = indexSet
                        showDeleteConfirmation = true
                    }
                }
                .listStyle(.insetGrouped)

                VStack {
                    Text("Total: $\(totalCost, specifier: "%.2f")")
                        .font(.headline)
                        .padding()
                }
            }
            .navigationTitle("Shopping List")
            .toolbar {
                Button(action: { showAddItemSheet = true }) {
                    Label("Add Item", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showAddItemSheet) {
                AddItemView(products: $products, categories: $categories, saveAction: saveProducts)
            }
            .sheet(item: $selectedProduct) { product in
                EditItemView(product: product, products: $products, saveAction: saveProducts)
            }
            .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let indexSet = indexToDelete {
                        products.remove(atOffsets: indexSet)
                        saveProducts()
                    }
                }
            }
        }
        .onAppear {
            loadProducts()
        }
    }

    func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: "savedProducts")
        }
    }

    func loadProducts() {
        if let savedData = UserDefaults.standard.data(forKey: "savedProducts"),
           let decoded = try? JSONDecoder().decode([Product].self, from: savedData) {
            products = decoded
        }
    }
}
