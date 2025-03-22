import SwiftUI

struct SessionInfoView: View {
    let session: Session

    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Text("Session")
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(){
                        Text("Nom de la session :")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Text("\(session.name)")
                            .font(.custom("Poppins-Light", size: 13))
                    }
                    HStack(){
                        Text("Date de début :")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Text("\(formatDate(session.startDate))")
                            .font(.custom("Poppins-Light", size: 13))
                    }
                    
                    HStack(){
                        Text("Date de fin :")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Text("\(formatDate(session.endDate))")
                            .font(.custom("Poppins-Light", size: 13))
                    }
                    
                    HStack(){
                        Text("Frais de dépôt :")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Text("\(session.depositFee)€ par article")
                            .font(.custom("Poppins-Light", size: 13))
                    }
                    
                    HStack(){
                        Text("Nombre d'articles avant réduction :")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Text("\(session.depositFeeLimitBeforeDiscount)")
                            .font(.custom("Poppins-Light", size: 13))
                    }
                    
                    HStack(){
                        Text("Réduction :")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Text("\(session.depositFeeDiscount)% du total")
                            .font(.custom("Poppins-Light", size: 13))
                    }
                    
                    HStack(){
                        Text("Commission après vente :")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Text("\(session.saleComission)% par article")
                            .font(.custom("Poppins-Light", size: 13))
                    }
                }
                .padding()
                .frame(width: 340)
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
