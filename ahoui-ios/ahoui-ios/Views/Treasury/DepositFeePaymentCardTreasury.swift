import SwiftUI

struct DepositFeePaymentCardTreasury: View {
    let payment: DepositFeePayment

    var body: some View {
        VStack(alignment: .leading) {
            Text("Frais de dépôt")
                .font(.system(size: 17, weight: .bold))

            Text("Date : \(formatDate(payment.depositDate))")
                .font(.system(size: 12, weight: .semibold))

            Text("Vendeur : \(payment.sellerId.name)")
                .font(.system(size: 11))
                .foregroundColor(.gray)

            Text("Session : \(payment.sessionId?.name ?? "Session inconnue")")
                .font(.system(size: 11))
                .foregroundColor(.gray)

            HStack {
                Spacer()
                Text("\(payment.depositFeePayed, specifier: "%.2f")€")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .frame(width: 328, height: 116)
        .background(Color.white.opacity(0.85))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 1))
    }
}
