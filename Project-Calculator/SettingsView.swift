//Mustafa Bandukda - 101203879
//Jaeden Salandanan - 101324631
//Fredrich Tan -  101318950
//Hamzah Hafez - 101429091
import SwiftUI

struct SettingsView: View {
    @AppStorage("currencyType") private var currencyType: String = "CAD"
    @AppStorage("customCategories") private var customCategoriesData: Data = Data()
    @Environment(\.dismiss) private var dismiss

    @State private var customCategories: [String] = []
    @State private var newCategory: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Enable Notifications", isOn: .constant(true)) // Placeholder
                    Picker("Currency Type", selection: $currencyType) {
                        Text("CAD").tag("CAD")
                        Text("USD").tag("USD")
                    }
                }

                Section(header: Text("Add Custom Category")) {
                    HStack {
                        TextField("New Category", text: $newCategory)
                        Button("Add") {
                            let trimmed = newCategory.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty, !customCategories.contains(trimmed) else { return }
                            customCategories.append(trimmed)
                            saveCategories()
                            newCategory = ""
                        }
                    }
                }

                Section(header: Text("Custom Categories")) {
                    if customCategories.isEmpty {
                        Text("No custom categories yet.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(customCategories, id: \.self) { category in
                            Text(category)
                        }
                        .onDelete(perform: deleteCategory)
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
            .onAppear {
                loadCategories()
            }
        }
    }

    func saveCategories() {
        if let data = try? JSONEncoder().encode(customCategories) {
            customCategoriesData = data
        }
    }

    func loadCategories() {
        if let loaded = try? JSONDecoder().decode([String].self, from: customCategoriesData) {
            customCategories = loaded
        }
    }

    func deleteCategory(at offsets: IndexSet) {
        customCategories.remove(atOffsets: offsets)
        saveCategories()
    }
}
