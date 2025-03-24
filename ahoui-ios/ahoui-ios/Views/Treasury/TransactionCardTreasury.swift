import SwiftUI
struct TransactionCardTreasury: View {
    let transaction: TransactionList

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Vente de jeu")
                .font(.custom("Poppins-Bold", size: 17))
                .foregroundColor(.black)

            Text("Vendeur : \(transaction.seller.name)")
                .font(.custom("Poppins-Bold", size: 11))
                .foregroundColor(Color(red: 0.406, green: 0.406, blue: 0.406))
                .lineSpacing(3)
            
            Text("Session : \(transaction.session.name)")
                .font(.custom("Poppins-Bold", size: 11))
                .foregroundColor(Color(red: 0.406, green: 0.406, blue: 0.406))
                .lineSpacing(3)

            Text("Jeu : \(transaction.label.gameDescription.name)")
                .font(.custom("Poppins-Bold", size: 11))
                .foregroundColor(Color(red: 0.406, green: 0.406, blue: 0.406))
                .lineSpacing(3)


            HStack {
                Spacer()
                Text("\(transaction.label.salePrice, specifier: "%.2f")€")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(Color(red: 0.298, green: 0.639, blue: 0.294)) // vert
            }
        }
        .padding()
        .frame(width: 328, height: 150)
        .background(Color.white.opacity(0.85))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 0.298, green: 0.639, blue: 0.294), lineWidth: 1))
    }
}
