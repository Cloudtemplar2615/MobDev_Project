import SwiftUI

struct TotalBreakdownView: View {
    let subtotal: Double
    let taxTotal: Double
    let grandTotal: Double

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray.opacity(0.4))
                .padding(.top, 10)

            Text("🧾 Cost Breakdown")
                .font(.title2.bold())

            VStack(spacing: 8) {
                HStack {
                    Text("Subtotal")
                    Spacer()
                    Text("$\(subtotal, specifier: "%.2f")")
                }
                HStack {
                    Text("Tax")
                    Spacer()
                    Text("$\(taxTotal, specifier: "%.2f")")
                }
                Divider()
                HStack {
                    Text("Total")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(grandTotal, specifier: "%.2f")")
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            .padding(.horizontal)

            Spacer()

            Button("Close") {
                dismiss()
            }
            .padding(.bottom)
        }
        .padding()
    }
}

