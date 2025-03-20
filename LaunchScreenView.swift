//
//  LaunchScreenView.swift
//  Project-Calculator
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @Environment(\.colorScheme) var colorScheme // Detects Light/Dark Mode

    var body: some View {
        if isActive {
            ContentView() // Navigate to the main view
        } else {
            VStack {
                Text("Shopping List App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary) // Auto-adjusts for Dark Mode
                    .padding()

                ProgressView()
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(colorScheme == .dark ? Color.black : Color.white) // Adapts to Dark Mode
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isActive = true
                }
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

