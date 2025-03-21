import SwiftUI

struct EditManagerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = ManagerViewModel()
    
    var manager: Manager

    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var phone: String
    @State private var address: String
    @State private var isAdmin: Bool
    @State private var errorMessage: String?
    @State private var isLoading = false

    init(manager: Manager) {
        self.manager = manager
        _firstName = State(initialValue: manager.firstName)
        _lastName = State(initialValue: manager.lastName)
        _email = State(initialValue: manager.email)
        _phone = State(initialValue: manager.phone)
        _address = State(initialValue: manager.address)
        _isAdmin = State(initialValue: manager.admin)
    }

    var body: some View {
        ZStack {
            Color(red: 1, green: 0.965, blue: 0.922)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Modifier le manager")
                    .font(.custom("Poppins-SemiBold", size: 25))
                    .foregroundColor(.black)
                    .padding(.top, 30)

                Spacer(minLength: 20)

                VStack(alignment: .leading, spacing: 15) {
                    CustomTextFieldNewManager(label: "Prénom", placeholder: "Entrez le prénom", text: $firstName)
                    CustomTextFieldNewManager(label: "Nom", placeholder: "Entrez le nom", text: $lastName)
                    CustomTextFieldNewManager(label: "Email", placeholder: "Entrez l’email", text: $email)
                    CustomTextFieldNewManager(label: "Numéro de téléphone", placeholder: "Entrez le numéro de téléphone", text: $phone)
                    CustomTextFieldNewManager(label: "Adresse", placeholder: "Entrez l’adresse", text: $address)

                    Toggle("Admin ?", isOn: $isAdmin)
                        .padding(.horizontal, 20)
                        .font(.custom("Poppins-Light", size: 12))
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                .frame(width: 300)

                Spacer(minLength: 20)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    Task {
                        await updateManager()
                    }
                }) {
                    Text("Enregistrer")
                        .font(.custom("Poppins-Light", size: 14))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 120)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                }
                .disabled(isLoading || firstName.isEmpty || lastName.isEmpty || email.isEmpty)
            }
            .padding()
        }
    }

    private func updateManager() async {
        isLoading = true
        errorMessage = nil

        let updatedManager = UpdateManager(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            address: address,
            admin: isAdmin
        )

        do {
            try await viewModel.updateManager(id: manager.id, updatedManager: updatedManager)
            presentationMode.wrappedValue.dismiss()
        } catch {
            errorMessage = "Échec de la mise à jour: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
