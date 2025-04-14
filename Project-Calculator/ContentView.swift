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
    @State private var showDeleteItemSheet = false
    @State private var productToDelete: Product?
    @State private var showSettings = false
    @State private var searchText = ""
    @State private var showAbout = false

    let taxRates: [String: Double] = [
        "Food": 0.05,
        "Medication": 0.00,
        "Cleaning": 0.13,
        "Other": 0.13
    ]

    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var totalCost: Double {
        products.reduce(0) { total, product in
            let taxRate = taxRates[product.category] ?? 0.13
            return total + product.price + (product.price * taxRate)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Item count display
                Text("Total items: \(products.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 5)

                List {
                    ForEach(filteredProducts) { product in
                        HStack {
                            Text("\(categoryEmoji(for: product.category)) \(product.name)")
                            Spacer()
                            Text("$\(product.price, specifier: "%.2f")")
                                .foregroundColor(.gray)
                        }
                        Button(role: .destructive) {
                            productToDelete = product
                            showDeleteItemSheet = true
                        } label: {
                            Image(systemName: "pencil")
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
                .searchable(text: $searchText, prompt: "Search products")

                VStack {
                    Text("Total: $\(totalCost, specifier: "%.2f")")
                        .font(.headline)

                    // Last updated timestamp
                    if let lastUpdated = UserDefaults.standard.object(forKey: "lastUpdated") as? Date {
                        Text("Last updated: \(lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                    }
                }
                .padding()
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddItemSheet = true }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAbout = true }) {
                        Label("About", systemImage: "info.circle")
                    }
                }
            }
            .sheet(isPresented: $showAddItemSheet) {
                AddItemView(products: $products, categories: $categories, saveAction: saveProducts)
            }
            .sheet(isPresented: $showAbout) {
                NavigationView {
                    AboutView()
                }
            }
            .sheet(isPresented: $showDeleteItemSheet) {
                if let productToDelete = productToDelete {
                    DeleteItemView(
                        product: Binding(
                            get: { productToDelete },
                            set: { self.productToDelete = $0 }
                        ),
                        isEditing: $showDeleteItemSheet,
                        products: $products
                    )
                }
            }
            .sheet(item: $selectedProduct) { product in
                EditItemView(product: product, products: $products, saveAction: saveProducts)
            }
            .sheet(isPresented: $showSettings) {
                NavigationView {
                    SettingsView()
                }
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
            UserDefaults.standard.set(Date(), forKey: "lastUpdated") // ✅ Save last update time
        }
    }

    func loadProducts() {
        if let savedData = UserDefaults.standard.data(forKey: "savedProducts"),
           let decoded = try? JSONDecoder().decode([Product].self, from: savedData) {
            products = decoded
        }
    }

    
    func categoryEmoji(for category: String) -> String {
        switch category {
        case "Food": return "🍎"
        case "Medication": return "💊"
        case "Cleaning": return "🧼"
        case "Other": return "📦"
        default: return "🛒"
        }
    }
}

