import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isMenuOpen = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ZStack {
                // ✅ Fond beige clair
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()
                Spacer()
                VStack(spacing: 30) {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()

                    // ✅ Titre "CONNEXION"
                    Text("CONNEXION")
                        .font(.custom("Poppins-Bold", size: 30))
                        .foregroundColor(.black)

                    // ✅ Zone de formulaire avec ombre et fond blanc semi-transparent
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

                    )

                    // ✅ Bouton "Connexion"
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

                    // ✅ Message d’erreur
                    if let loginError = viewModel.loginError {
                        Text(loginError)
                            .foregroundColor(.red)
                            .font(.custom("Poppins-SemiBold", size: 16))
                            .padding(.top, 5)
                    }

                    Spacer()

                    // ✅ Fleur centrée en bas
                    Image("logoBIGFLEUR")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
                        .padding(.bottom, 40)
                }

                // ✅ Navbar par-dessus
                NavBarView(isMenuOpen: $isMenuOpen)
                    .environmentObject(viewModel)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $viewModel.shouldNavigateToHome) {
                HomeView()
            }
        }
    }
}
