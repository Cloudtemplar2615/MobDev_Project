//
//  ContentView.swift
//  Project-Calculator
//

import SwiftUI
import Foundation

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
    @State private var selectedProduct: Product?
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    @State private var itemToDelete: IndexSet?

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
        TabView {
            NavigationView {
                VStack {
                    List {
                        ForEach(products.indices, id: \.self) { index in
                            HStack {
                                Text(products[index].name)
                                    .foregroundColor(.primary) // Adapts to Dark Mode
                                Spacer()
                                Text("$\(products[index].price, specifier: "%.2f")")
                                    .foregroundColor(.gray)
                            }
                            .contentShape(Rectangle()) // Makes the entire row tappable
                            .onTapGesture {
                                selectedProduct = products[index]
                                isEditing = true
                            }
                        }
                        .onDelete(perform: deleteProduct)
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
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddItemSheet = true }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showAddItemSheet) {
                    AddItemView(products: $products, categories: $categories, saveAction: saveProducts)
                }
                .sheet(isPresented: $isEditing) {
                    if let index = products.firstIndex(where: { $0.id == selectedProduct?.id }) {
                        EditItemView(product: $products[index], isEditing: $isEditing)
                    }
                }
                .alert("Are you sure you want to delete this item?", isPresented: $showDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        if let offsets = itemToDelete {
                            products.remove(atOffsets: offsets)
                            saveProducts()
                        }
                    }
                }
            }
            .tabItem { Label("List", systemImage: "cart") }

            AboutView()
                .tabItem { Label("About", systemImage: "info.circle") }
        }
        .onAppear {
            loadProducts()
        }
    }

    func deleteProduct(at offsets: IndexSet) {
        itemToDelete = offsets
        showDeleteAlert = true
    }

    func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: "savedProducts")
        }
    }

    func loadProducts() {
        if let savedData = UserDefaults.standard.data(forKey: "savedProducts") {
            if let decoded = try? JSONDecoder().decode([Product].self, from: savedData) {
                products = decoded
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

