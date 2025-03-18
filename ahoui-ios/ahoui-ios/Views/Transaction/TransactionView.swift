import SwiftUI

struct TransactionView: View {
    let transaction: Transaction

    // Format the transaction date
    var formattedDate: String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"

        if let date = inputFormatter.date(from: transaction.transactionDate) {
            return outputFormatter.string(from: date)
        }
        return transaction.transactionDate // Fallback in case of error
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // ID
            Text("ID : \(transaction.id)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)

            // Date
            Text("Date : \(formattedDate)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Game Name
            Text("Jeu : \(transaction.label.gameDescription.name)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Sale Price
            Text("Prix de vente : \(String(format: "%.2f", transaction.label.salePrice))€")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Client Info
            Text("Nom client : \(transaction.client.name)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            Text("Email client : \(transaction.client.email)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Session Name
            Text("Session : \(transaction.session.name)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // Manager in Charge
            Text("Manager en charge : \(transaction.manager.firstName) \(transaction.manager.lastName)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
        }
        .padding()
        .frame(width: 300)
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
    }
}
