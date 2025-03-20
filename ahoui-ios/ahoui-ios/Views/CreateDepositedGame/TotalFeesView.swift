import SwiftUI

struct TotalFeesView: View {
    @ObservedObject var viewModel: CreateDepositedGameViewModel
    let session: Session

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("TOTAL")
                .font(.custom("Poppins-SemiBold", size: 20))
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 5) {
                Text("Total frais de dépôt : \(String(format: "%.2f", viewModel.totalDepositFee))€")
                    .font(.custom("Poppins-SemiBold", size: 12))

                Text("Total réduction frais : \(String(format: "%.2f", viewModel.totalDiscount))€")
                    .font(.custom("Poppins-SemiBold", size: 12))

                Text("Total après réduction : \(String(format: "%.2f", viewModel.totalAfterDiscount))€")
                    .font(.custom("Poppins-SemiBold", size: 12))
            }
            .padding()
            .frame(width: 284)
            .background(Color.white.opacity(0.5))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
        }
        .onAppear {
            viewModel.initializeTotals(with: session) // ✅ Initialisation des totaux avec depositFee
        }
    }
}
