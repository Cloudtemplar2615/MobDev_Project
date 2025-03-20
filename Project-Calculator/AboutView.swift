//
//  AboutView.swift
//  Project-Calculator
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("About This App")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            VStack(alignment: .leading, spacing: 10) {
                Text("Developed by:")
                    .font(.headline)

                Text("• Mustafa Bandukda - 101203879")
                Text("• Jaeden Salandanan - 101324631")
                Text("• Fredrich Tan -  101318950")
                Text("• Hamzah Hafez - 101429091")
            }
            .padding()

            Spacer()
        }
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}

