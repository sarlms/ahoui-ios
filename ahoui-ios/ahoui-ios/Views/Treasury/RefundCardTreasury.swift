import SwiftUI

struct RefundCardTreasury: View {
    let refund: Refund

    var body: some View {
        VStack(alignment: .leading) {
            Text("Remboursement")
                .font(.system(size: 17, weight: .bold))

            Text("Date : \(formatDate(refund.refundDate))")
                .font(.system(size: 12, weight: .semibold))

            Text("Vendeur : \(refund.sellerId.name)")
                .font(.system(size: 11))
                .foregroundColor(.gray)

            Text("Session : \(refund.sessionId?.name ?? "Session inconnue")") // ✅ Handles nil case
                .font(.system(size: 11))
                .foregroundColor(.gray)

            HStack {
                Spacer()
                Text("-\(refund.refundAmount, specifier: "%.2f")€")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.red)
            }
        }
        .padding()
        .frame(width: 328, height: 116)
        .background(Color.white.opacity(0.85))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.red, lineWidth: 1))
    }
}
