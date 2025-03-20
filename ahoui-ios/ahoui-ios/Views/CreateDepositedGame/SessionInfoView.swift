import SwiftUI

struct SessionInfoView: View {
    let session: Session

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Session")
                .font(.custom("Poppins-SemiBold", size: 20))
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 5) {
                Text("Nom de la session : \(session.name)")
                    .font(.custom("Poppins-SemiBold", size: 14))

                Text("Date de début : \(formatDate(session.startDate))")
                    .font(.custom("Poppins-SemiBold", size: 14))

                Text("Date de fin : \(formatDate(session.endDate))")
                    .font(.custom("Poppins-SemiBold", size: 14))

                Text("Frais de dépôt : \(String(format: "%.2f", session.depositFee))€ par article")
                    .font(.custom("Poppins-SemiBold", size: 14))

                Text("Nombre d'articles avant réduction : \(session.depositFeeLimitBeforeDiscount)")
                    .font(.custom("Poppins-SemiBold", size: 14))

                Text("Réduction : \(session.depositFeeDiscount)% du total")
                    .font(.custom("Poppins-SemiBold", size: 14))

                Text("Commission après vente : \(session.saleComission)% par article")
                    .font(.custom("Poppins-SemiBold", size: 14))
            }
            .padding()
            .frame(width: 284)
            .background(Color.white.opacity(0.5))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
        }
    }

    func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // ✅ Ajout du support pour les millisecondes
        
        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "fr_FR") // ✅ Français
            formatter.dateFormat = "dd/MM/yyyy HH:mm" // ✅ Format voulu
            return formatter.string(from: date)
        }
        
        // 🔴 Si le format ISO ne fonctionne pas, essayons un autre format courant
        let alternativeFormatter = DateFormatter()
        alternativeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = alternativeFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "fr_FR")
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            return formatter.string(from: date)
        }

        return dateString // 🔴 Si aucun format ne fonctionne, on retourne la date brute
    }

}
