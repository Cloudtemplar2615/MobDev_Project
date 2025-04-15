//
//  PieChartView.swift
//  Project-Calculator
//
//
//
//Fredrich Tan -  101318950
//
//
import SwiftUI
import Charts

struct CategoryTotal: Identifiable {
    let id = UUID()
    let category: String
    let total: Double
    let products: [Product]
}

struct PieChartView: View {
    var products: [Product]

    @State private var selectedCategory: CategoryTotal? = nil
    @State private var showDetailSheet = false

    var categoryTotals: [CategoryTotal] {
        let grouped = Dictionary(grouping: products, by: { $0.category })
        return grouped.map { (key, items) in
            let total = items.reduce(0) { $0 + $1.price }
            return CategoryTotal(category: key, total: total, products: items)
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Spending by Category")
                .font(.title2.bold())

            if categoryTotals.isEmpty {
                Text("No data yet")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Chart(categoryTotals) { item in
                    SectorMark(
                        angle: .value("Amount", item.total),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(by: .value("Category", item.category))
                    .annotation(position: .overlay) {
                        Text(item.category)
                            .font(.caption)
                            .bold()
                    }
                }
                .frame(height: 300)
                .padding(.horizontal)

                Divider()
                // allows user to tap to show breakdown for category
                List(categoryTotals) { item in
                    Button {
                        selectedCategory = item
                        showDetailSheet = true
                    } label: {
                        HStack {
                            Text(item.category)
                            Spacer()
                            Text("$\(item.total, specifier: "%.2f")")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .frame(height: 200)
            }
        }
        .padding()
        .sheet(isPresented: $showDetailSheet) {
            if let selected = selectedCategory {
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(selected.category)")
                        .font(.title2.bold())
                    Text("Total: $\(selected.total, specifier: "%.2f")")
                        .font(.headline)
                        .padding(.bottom, 5)

                    List(selected.products) { product in
                        HStack {
                            Text(product.name)
                            Spacer()
                            Text("$\(product.price, specifier: "%.2f")")
                                .foregroundColor(.gray)
                        }
                    }
                    .listStyle(.insetGrouped)

                    Button("Close") {
                        showDetailSheet = false
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .presentationDetents([.medium, .large])
            }
        }
    }
}
