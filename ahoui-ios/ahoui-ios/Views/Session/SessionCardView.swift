import SwiftUI

struct SessionCardView: View {
    let session: Session
    let sessionService: SessionService
    @EnvironmentObject var authViewModel: AuthViewModel // Vérifie si le manager est connecté
    @State private var showDeleteConfirmation = false // Affiche la confirmation avant suppression

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(session.name)
                .font(.system(size: 18, weight: .bold))

            Text("Date : \(sessionService.formatDate(session.startDate)) - \(sessionService.formatDate(session.endDate))")
                .font(.system(size: 14, weight: .bold))
            
            Text("Horaires : \(sessionService.formatTime(session.startDate)) - \(sessionService.formatTime(session.endDate))")
                .font(.system(size: 14, weight: .bold))

            Text("Lieu : \(session.location)")
                .font(.system(size: 14, weight: .bold))

            HStack {
                Text("Status :")
                    .font(.system(size: 14, weight: .bold))

                Text(sessionStatus())
                    .foregroundColor(statusColor())
                    .fontWeight(.bold)
            }

            // Bouton "Catalogue" si la session est ouverte ou clôturée
            if sessionStatus() != "À venir" {
                Button(action: {
                    print("Catalogue tapped for session: \(session.name)")
                }) {
                    Text("Catalogue")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
            }

            // Bouton "Supprimer ?" si la session est "À venir" et le manager connecté
            if sessionStatus() == "À venir" && authViewModel.isAuthenticated {
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Text("Supprimer ?")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.red)
                        .underline()
                }
                .padding(.top, 8)
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Confirmer la suppression"),
                        message: Text("Êtes-vous sûr de vouloir supprimer cette session ?"),
                        primaryButton: .destructive(Text("Oui, supprimer")) {
                            deleteSession()
                        },
                        secondaryButton: .cancel(Text("Annuler"))
                    )
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(.horizontal)
    }

    // Fonction pour déterminer le statut d'une session
    func sessionStatus() -> String {
        let now = Date()
        let startDate = isoDateFormatter.date(from: session.startDate) ?? Date.distantPast
        let endDate = isoDateFormatter.date(from: session.endDate) ?? Date.distantPast

        if now >= startDate && now <= endDate {
            return "En cours"
        } else if now < startDate {
            return "À venir"
        } else {
            return "Clôturée"
        }
    }

    // Fonction pour définir la couleur du texte du statut
    func statusColor() -> Color {
        switch sessionStatus() {
        case "En cours":
            return .green
        case "À venir":
            return .blue
        case "Clôturée":
            return .pink
        default:
            return .black
        }
    }

    // Fonction pour supprimer une session via `SessionService`
    func deleteSession() {
        guard let authToken = authViewModel.authToken else {
            print("❌ Impossible de supprimer : Aucun token trouvé")
            return
        }

        sessionService.deleteSession(sessionId: session.id, authToken: authToken) { success in
            DispatchQueue.main.async {
                if success {
                    print("✅ Session supprimée avec succès")
                    // Optionnel : actualiser la liste après suppression
                    NotificationCenter.default.post(name: NSNotification.Name("SessionDeleted"), object: nil)
                } else {
                    print("❌ Échec de la suppression")
                }
            }
        }
    }
}

// Formatter ISO 8601
private let isoDateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
}()
