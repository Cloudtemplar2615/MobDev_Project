//
//  ContentView.swift
//  Project-Calculator
//
//
import SwiftUI
import Foundation

struct Product: Identifiable, Codable {
    var id = UUID()
    let name: String
    let price: Double
    let category: String
    
    init(id:UUID = UUID(), name: String, price: Double, category: String){
        self.id = id
        self.name = name
        self.price = price
        self.category = category
    }
}

struct ContentView: View {
    @State private var products: [Product] = []
    @State private var categories: [String] = ["Food", "Medication", "Cleaning", "Other"]
    @State private var showAddItemSheet = false
    
    //define different tax rates per category
    let taxRates: [String: Double] = [
        "Food": 0.05,
        "Medication": 0.00,
        "Cleaning": 0.13,
        "Other": 0.13
    ]
    
    //compute total cost including category specific tax
    var totalCost: Double {
        let subtotal = products.reduce(0) { (total, product) in
            let taxRate = taxRates[product.category] ?? 0.13  // Default 13%
            return total + product.price + (product.price * taxRate)
        }
        return subtotal
    }
    
    var body: some View {
        TabView {
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
                    Button(action: { showAddItemSheet = true }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                .sheet(isPresented: $showAddItemSheet) {
                    AddItemView(products: $products, categories: $categories, saveAction: saveProducts)
                }
            }
            .tabItem { Label("List", systemImage: "cart") }
            
            AboutView()
                .tabItem { Label("About", systemImage: "info.circle") }
        }
        .onAppear {
            loadProducts() //load saved items when the app starts
        }
    }
    
    //delete item from list
    func deleteProduct(at offsets: IndexSet) {
        products.remove(atOffsets: offsets)
        saveProducts() // Save changes
    }
    
    //save products to UserDefaults
    func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: "savedProducts")
            print("Products saved: \(products)")
        }else{
            print("failed to encode products")
        }
    }
    
    //load products from UserDefaults
    func loadProducts() {
        if let savedData = UserDefaults.standard.data(forKey: "savedProducts"){
            if let decoded = try? JSONDecoder().decode([Product].self, from: savedData){
                products = decoded
                print("Products loaded: \(products)")
            } else {
                    print("Failed to decode products")
            }
        }else {
            print("No saved data found")
        }
    }
    
    //
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    
    
    
}
