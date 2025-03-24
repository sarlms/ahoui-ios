import SwiftUI

struct ClientDetailView: View {
    @EnvironmentObject var viewModel: ClientViewModel
    @Environment(\.dismiss) var dismiss
    let client: Client

    @State private var name: String
    @State private var email: String
    @State private var phone: String
    @State private var address: String
    @State private var showDeleteAlert = false

    init(client: Client) {
        self.client = client
        _name = State(initialValue: client.name)
        _email = State(initialValue: client.email)
        _phone = State(initialValue: client.phone)
        _address = State(initialValue: client.address)
    }

    var body: some View {
        ZStack {
            Color(red: 1, green: 0.965, blue: 0.922)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Modifier le client")
                    .font(.custom("Poppins-SemiBold", size: 25))
                    .foregroundColor(.black)
                    .padding(.top, 30)

                Spacer(minLength: 20)

                VStack(alignment: .leading, spacing: 15) {
                    StyledClientInputField(title: "Nom", text: $name)
                    StyledClientInputField(title: "Email", text: $email)
                    StyledClientInputField(title: "Numéro de téléphone", text: $phone)
                    StyledClientInputField(title: "Adresse", text: $address)
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                .frame(width: 300)

                Spacer(minLength: 20)

                HStack(spacing: 15) {
                    Button(action: updateClient) {
                        Text("Modifier")
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 120)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                    }

                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Text("Supprimer")
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundColor(.red)
                            .padding()
                            .frame(width: 120)
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.red, lineWidth: 1))
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("Confirmer la suppression")
                                .font(.custom("Poppins-SemiBold", size: 14)),
                            message: Text("Êtes-vous sûr de vouloir supprimer ce client ?")
                                .font(.custom("Poppins", size: 13)),
                            primaryButton: .destructive(Text("Supprimer")
                                .font(.custom("Poppins-Medium", size: 13))) {
                                    deleteClient()
                                },
                            secondaryButton: .cancel(Text("Annuler")
                                .font(.custom("Poppins-Medium", size: 13)))
                        )
                    }
                }

                Spacer()
            }
            .padding()
        }
    }

    func updateClient() {
        let updatedClient = Client(id: client.id, name: name, email: email, phone: phone, address: address)
        viewModel.updateClient(client: updatedClient) { success in
            if success {
                viewModel.fetchClients()
                dismiss()
            }
        }
    }

    func deleteClient() {
        viewModel.deleteClient(clientId: client.id) { success in
            if success {
                dismiss()
            }
        }
    }
}

struct StyledClientInputField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(.black)

            TextField("", text: $text)
                .font(.custom("Poppins", size: 13))
                .padding(10)
                .background(Color.white.opacity(0.5))
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
        }
        .padding(.horizontal, 20)
    }
}

