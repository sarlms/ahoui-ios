import SwiftUI

struct SessionCardView: View {
    let session: Session
    let sessionService: SessionService
    @EnvironmentObject var authViewModel: AuthViewModel // Vérifie si le manager est connecté
    @State private var showDeleteConfirmation = false // Affiche la confirmation avant suppression
    @State private var shouldNavigate = false


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 8) {
                    GridRow(alignment: .top) {
                        Text(session.name)
                            .font(.custom("Poppins-Bold", size: 23))
                            .gridCellColumns(2)
                    }

                    GridRow(alignment: .top) {
                        Text("Date de début :")
                            .font(.custom("Poppins-Bold", size: 15))

                        Text(sessionService.formatDate(session.startDate))
                            .font(.custom("Poppins-Light", size: 15))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // ✅ ici
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    GridRow(alignment: .top) {
                        Text("Date de fin :")
                            .font(.custom("Poppins-Bold", size: 15))

                        Text(sessionService.formatDate(session.endDate))
                            .font(.custom("Poppins-Light", size: 15))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    GridRow(alignment: .top) {
                        Text("Horaires :")
                            .font(.custom("Poppins-Bold", size: 15))

                        Text("\(sessionService.formatTime(session.startDate)) - \(sessionService.formatTime(session.endDate))")
                            .font(.custom("Poppins-Light", size: 15))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    GridRow(alignment: .top) {
                        Text("Lieu :")
                            .font(.custom("Poppins-Bold", size: 15))

                        Text(session.location)
                            .font(.custom("Poppins-Light", size: 15))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    GridRow(alignment: .top) {
                        Text("Status :")
                            .font(.custom("Poppins-Bold", size: 15))

                        Text(sessionStatus())
                            .foregroundColor(statusColor())
                            .font(.custom("Poppins-Light", size: 15))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }


                Spacer() // ⬅️ empêche le centrage du bloc Grid
            }


            /*
            // Bouton "Catalogue" si la session est ouverte ou clôturée
            if sessionStatus() != "À venir" {
                VStack {
                    Button(action: {
                        print("Catalogue tapped for session: \(session.name)")
                        shouldNavigate = true
                    }) {
                        Text("Catalogue")
                            .font(.custom("Poppins-SemiBold", size: 18))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)

                    // 🔁 Navigation conditionnelle
                    NavigationLink(
                        destination: CatalogueView(
                            viewModel: DepositedGameViewModel(service: DepositedGameService()),
                            sessionViewModel: SessionViewModel()
                        ),
                        isActive: $shouldNavigate
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
            }*/

            // Bouton "Supprimer ?" si la session est "À venir" et le manager connecté
            if sessionStatus() == "À venir" && authViewModel.isAuthenticated {
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Text("Supprimer ?")
                        .font(.custom("Poppins-Medium", size: 16))
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
        .frame(minWidth: 320) 
        .padding(20)
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(.horizontal)
        .navigationDestination(isPresented: $shouldNavigate) {
            SessionListView()
        }
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
                    shouldNavigate = true // 👉 déclenche la navigation
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
