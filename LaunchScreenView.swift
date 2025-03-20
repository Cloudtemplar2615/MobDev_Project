//
//  LaunchScreenView.swift
//  Project-Calculator
//
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView() 
        } else {
            VStack {
                Text("Shopping List App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()

                Text("By Group ")
                    .font(.title3)
                    .foregroundColor(.gray)

                ProgressView()
                    .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}

