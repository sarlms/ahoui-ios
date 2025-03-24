import SwiftUI

struct RefundCardTreasury: View {
    let refund: Refund

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Remboursement")
                .font(.custom("Poppins-Bold", size: 17))
                .foregroundColor(.black)

            Text("Vendeur : \(refund.sellerId.name)")
                .font(.custom("Poppins-Bold", size: 11))
                .foregroundColor(Color(red: 0.406, green: 0.406, blue: 0.406))
                .lineSpacing(3)
            
            
            Text("Session : \(refund.sessionId?.name ?? "Session inconnue")")
                .font(.custom("Poppins-Bold", size: 11))
                .foregroundColor(Color(red: 0.406, green: 0.406, blue: 0.406))
                .lineSpacing(3)

            HStack {
                Spacer()
                Text("-\(refund.refundAmount, specifier: "%.2f")€")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(Color(red: 1, green: 0.235, blue: 0.196)) // rouge
            }
        }
        .padding()
        .frame(width: 328, height: 140)
        .background(Color.white.opacity(0.85))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 1, green: 0.235, blue: 0.196), lineWidth: 1))
    }
}

