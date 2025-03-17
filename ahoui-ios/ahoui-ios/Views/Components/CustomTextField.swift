import SwiftUI

// Champ de texte personnalisé réutilisable dans l'application
struct CustomTextField: View {
    var placeholder: String // Texte affiché tant que l'utilisateur n'a rien saisi
    @Binding var text: String // Liaison avec une variable pour stocker l'entrée utilisateur
    var isSecure: Bool = false // Indique si le champ doit masquer le texte (mot de passe)

    var body: some View {
        if isSecure {
            // Champ sécurisé pour la saisie des mots de passe
            SecureField(placeholder, text: $text)
                .padding()
                .background(Color.white.opacity(0.5)) // Fond semi-transparent
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1) // Bordure noire
                )
                .frame(width: 250, height: 50)
        } else {
            // Champ de texte classique pour les saisies normales
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .frame(width: 250, height: 50)
        }
    }
}
