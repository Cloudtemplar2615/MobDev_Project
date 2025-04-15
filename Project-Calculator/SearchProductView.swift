//
//  SearchProductView.swift
//  Project-Calculator
//
//
import SwiftUI

struct SearchProductView: View {
    @Binding var products: [Product]
    @State private var searchText = ""
    
    var filteredProducts: [Product] {
        products.filter { product in
            searchText.isEmpty || product.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        VStack {
            TextField("Search for products", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            List(filteredProducts) { product in
                Text(product.name)
            }
        }
        .navigationTitle("Search Products")
    }
}