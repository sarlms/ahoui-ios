import SwiftUI

struct DepositFeePaymentCardTreasury: View {
    let payment: DepositFeePayment

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Frais de dépôt")
                .font(.custom("Poppins-Bold", size: 17))
                .foregroundColor(.black)

            Text("Vendeur : \(payment.sellerId.name)")
                .font(.custom("Poppins-Bold", size: 11))
                .foregroundColor(Color(red: 0.406, green: 0.406, blue: 0.406))
                .lineSpacing(3)
            
            
            Text("Session : \(payment.sessionId?.name ?? "Session inconnue")")
                .font(.custom("Poppins-Bold", size: 11))
                .foregroundColor(Color(red: 0.406, green: 0.406, blue: 0.406))
                .lineSpacing(3)

            HStack {
                Spacer()
                Text("\(payment.depositFeePayed, specifier: "%.2f")€")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(Color(red: 0.262, green: 0.615, blue: 0.939)) // bleu
            }
        }
        .padding()
        .frame(width: 328, height: 140)
        .background(Color.white.opacity(0.85))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 0.262, green: 0.615, blue: 0.939), lineWidth: 1))
    }
}

