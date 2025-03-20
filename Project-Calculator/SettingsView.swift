//
//  SettingsView.swift
//  Project-Calculator
//
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("currencyType") private var currencyType: String = "CAD"
    
    var body: some View {
        List {
            Section(header: Text("General")) {
                Toggle("Enable Notifications", isOn: .constant(true))
                
                Picker("Currency Type", selection: $currencyType) {
                    Text("CAD").tag("CAD")
                    Text("USD").tag("USD")
                }
            }
        }
        .navigationTitle("Settings")
    }
}