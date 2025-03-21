import SwiftUI

struct TransactionCardTreasury: View {
    let transaction: TransactionList

    var body: some View {
        VStack(alignment: .leading) {
            Text("Vente de jeu")
                .font(.system(size: 17, weight: .bold))

            Text("Date : \(formatDate(transaction.transactionDate))")
                .font(.system(size: 12, weight: .semibold))

            Text("Vendeur : \(transaction.seller.name)")
                .font(.system(size: 11))
                .foregroundColor(.gray)

            Text("Session : \(transaction.session.name)")
                .font(.system(size: 11))
                .foregroundColor(.gray)

            Text("Jeu : \(transaction.label.gameDescription.name)")
                .font(.system(size: 11))
                .foregroundColor(.gray)

            HStack {
                Spacer()
                Text("\(transaction.label.salePrice, specifier: "%.2f")€")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(width: 328, height: 132)
        .background(Color.white.opacity(0.85))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.green, lineWidth: 1))
    }
}
