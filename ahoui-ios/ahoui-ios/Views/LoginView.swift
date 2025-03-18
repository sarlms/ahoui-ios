import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel  // ✅ Use the global AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Text("CONNEXION")
                    .font(.custom("Poppins-SemiBold", size: 30))
                    .foregroundColor(.black)

                VStack(spacing: 15) {
                    CustomTextField(placeholder: "Adresse email", text: $viewModel.email)
                    CustomTextField(placeholder: "Mot de passe", text: $viewModel.password, isSecure: true)
                }
                .padding()
                .frame(width: 288, height: 186)
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1)
                        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                )

                // 🔹 Connexion Button
                Button(action: viewModel.login) {
                    Text(viewModel.isLoading ? "Connexion..." : "Connexion")
                        .font(.custom("Poppins-Medium", size: 20))
                        .foregroundColor(.black)
                        .frame(width: 158, height: 52)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                        )
                }
                .disabled(viewModel.isLoading)

                // 🔹 Affichage des erreurs
                if let loginError = viewModel.loginError {
                    Text(loginError)
                        .foregroundColor(.red)
                        .font(.custom("Poppins-Medium", size: 16))
                        .padding(.top, 5)
                }
            }
            .padding()
            // 🔹 Navigation to HomeView when login is successful
            .navigationDestination(isPresented: $viewModel.shouldNavigateToHome) {
                HomeView()
            }
        }
    }
}
