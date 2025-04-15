//Mustafa Bandukda - 101203879
//Jaeden Salandanan - 101324631
//Fredrich Tan -  101318950
//Hamzah Hafez - 101429091
import SwiftUI

struct SettingsView: View {
    @AppStorage("currencyType") private var currencyType: String = "CAD"
    @Environment(\.dismiss) private var dismiss

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
        .toolbar {           
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}
