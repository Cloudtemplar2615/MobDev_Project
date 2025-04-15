//
//  SearchProductView.swift
//  Project-Calculator
//
//
//Mustafa Bandukda - 101203879
//Jaeden Salandanan - 101324631
//Fredrich Tan -  101318950
//Hamzah Hafez - 101429091

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
