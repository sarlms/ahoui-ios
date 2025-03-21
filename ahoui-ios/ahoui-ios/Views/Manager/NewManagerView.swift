import SwiftUI

struct NewManagerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ManagerViewModel
    //@StateObject private var viewModel = ManagerViewModel()
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var password = ""
    @State private var isAdmin = false
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color(red: 1, green: 0.965, blue: 0.922)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Nouveau manager")
                    .font(.custom("Poppins-SemiBold", size: 25))
                    .foregroundColor(.black)
                    .padding(.top, 30)
                
                Spacer(minLength: 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    CustomTextFieldNewManager(label: "Prénom", placeholder: "Entrez le prénom", text: $firstName)
                    CustomTextFieldNewManager(label: "Nom", placeholder: "Entrez le nom", text: $lastName)
                    CustomTextFieldNewManager(label: "Email", placeholder: "Entrez l’email", text: $email)
                    CustomTextFieldNewManager(label: "Numéro de téléphone", placeholder: "Entrez le numéro de téléphone", text: $phone)
                    CustomTextFieldNewManager(label: "Adresse", placeholder: "Entrez l’adresse du client", text: $address)
                    CustomTextFieldNewManager(label: "Mot de passe", placeholder: "Entrez le mot de passe", text: $password, isSecure: true)
                    
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
                        await createManager()
                    }
                }) {
                    Text("Créer")
                        .font(.custom("Poppins-Light", size: 14))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 120)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                }
                .disabled(isLoading || firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty)
            }
            .padding()
        }
    }
    
    private func createManager() async {
        isLoading = true
        errorMessage = nil

        let newManager = CreateManager(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            address: address,
            password: password,
            admin: isAdmin
        )

        do {
            try await viewModel.createManager(newManager)
            await viewModel.fetchManagers()
            presentationMode.wrappedValue.dismiss()
        } catch {
            errorMessage = "Échec de la création du manager: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

struct CustomTextFieldNewManager: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.custom("Poppins-Light", size: 12))
                .foregroundColor(.black)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding(10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
            } else {
                TextField(placeholder, text: $text)
                    .padding(10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
            }
        }
        .padding(.horizontal, 20)
    }
}
