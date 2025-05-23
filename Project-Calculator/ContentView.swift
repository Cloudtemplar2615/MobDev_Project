//
//  ContentView.swift
//  Project-Calculator
//Mustafa Bandukda - 101203879
//Jaeden Salandanan - 101324631
//Fredrich Tan -  101318950
//Hamzah Hafez - 101429091


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
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showBreakdownSheet = false

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

    var groupedProducts: [String: [Product]] {
        Dictionary(grouping: filteredProducts, by: { $0.category })
    }

    var subtotal: Double {
        products.reduce(0) { $0 + $1.price }
    }

    var taxTotal: Double {
        products.reduce(0) {
            $0 + ($1.price * (taxRates[$1.category] ?? 0.13))
        }
    }

    var totalCost: Double {
        subtotal + taxTotal
    }

    var body: some View {
        TabView {
            
            NavigationView {
                VStack {
                    Text("Total items: \(products.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                    // to show if no items exist for better
                    if products.isEmpty {
                        Text("🛒 Start by adding your first item!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                    }

                    List {
                        ForEach(groupedProducts.keys.sorted(), id: \ .self) { category in
                            Section(header: Text("\(categoryEmoji(for: category)) \(category)")) {
                                ForEach(groupedProducts[category]!) { product in
                                    HStack {
                                        Text("\(categoryEmoji(for: product.category)) \(product.name)")
                                        Spacer()
                                        Text("$\(product.price, specifier: "%.2f")")
                                            .foregroundColor(.gray)
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedProduct = product // edits screens
                                        showEditItemSheet = true
                                    }
                                }
                                // deletion
                                .onDelete { indexSet in
                                    for index in indexSet {
                                        let item = groupedProducts[category]![index]
                                        if let globalIndex = products.firstIndex(where: { $0.id == item.id }) {
                                            products.remove(at: globalIndex)
                                        }
                                    }
                                    saveProducts()
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .searchable(text: $searchText, prompt: "Search products")

                    VStack {
                        Text("Total: $\(totalCost, specifier: "%.2f")") // shows total + tax
                            .font(.headline)
                        // user taps allows detailed view
                            .onTapGesture {
                                showBreakdownSheet = true
                            }

                        if let lastUpdated = UserDefaults.standard.object(forKey: "lastUpdated") as? Date {
                            Text("Last updated: \(lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Shopping List (\(products.count) items)") // for dynamic title
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
            }
            .tabItem {
                Label("List", systemImage: "cart")
            }

            // a chart for category
            PieChartView(products: products)
                .tabItem {
                    Label("Chart", systemImage: "chart.pie.fill")
                }

            
            NavigationView {
                AboutView()
            }
            .tabItem {
                Label("About", systemImage: "info.circle")
            }
        }
        .onAppear {
            loadProducts()
        }
        .sheet(isPresented: $showAddItemSheet) {
            AddItemView(products: $products, categories: $categories, saveAction: {
                if let last = products.last {
                    if last.name.isEmpty {
                        products.removeLast()
                        alertMessage = "Item name cannot be empty."
                        showAlert = true
                        return
                    }
                    if last.price <= 0 {
                        products.removeLast()
                        alertMessage = "Please enter a valid price."
                        showAlert = true
                        return
                    }
                    saveProducts()
                }
            })
        }
        .sheet(isPresented: $showBreakdownSheet) {
            TotalBreakdownView(
                subtotal: subtotal,
                taxTotal: taxTotal,
                grandTotal: totalCost
            )
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
        .alert("Invalid Input", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
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

    func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: "savedProducts")
            UserDefaults.standard.set(Date(), forKey: "lastUpdated") // tracks date change
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


