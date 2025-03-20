import SwiftUI

struct ClientDetailView: View {
    @EnvironmentObject var viewModel: ClientViewModel
    @Environment(\.dismiss) var dismiss // not presentation mode because app crashed
    let client: Client

    @State private var name: String
    @State private var email: String
    @State private var phone: String
    @State private var address: String

    init(client: Client) {
        self.client = client
        _name = State(initialValue: client.name)
        _email = State(initialValue: client.email)
        _phone = State(initialValue: client.phone)
        _address = State(initialValue: client.address)
    }

    var body: some View {
        VStack {
            Text("Détails du client")
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(.black)
                .padding(.top, 20)

            VStack(alignment: .leading, spacing: 10) {
                InputFieldClientDetail(title: "Nom", text: $name)
                InputFieldClientDetail(title: "Email", text: $email)
                InputFieldClientDetail(title: "Numéro de téléphone", text: $phone)
                InputFieldClientDetail(title: "Adresse", text: $address)
            }
            .padding()
            .frame(width: 300)
            .background(Color.white.opacity(0.9))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
            .padding(.top, 20)

            HStack(spacing: 15) {
                Button(action: updateClient) {
                    Text("Modifier")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 100)
                        .background(Color.blue)
                        .cornerRadius(15)
                }

                Button(action: deleteClient) {
                    Text("Supprimer")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 100)
                        .background(Color.red)
                        .cornerRadius(15)
                }
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .background(Color(red: 1, green: 0.965, blue: 0.922).edgesIgnoringSafeArea(.all))
    }

    // Update client information on the backend
    func updateClient() {
        let updatedClient = Client(id: client.id, name: name, email: email, phone: phone, address: address)

        viewModel.updateClient(client: updatedClient) { success in
            if success {
                viewModel.fetchClients() // Refresh client list after update
                dismiss() // Navigate back to `ClientListView`
            }
        }
    }

    // Delete client from backend and closes view
    func deleteClient() {
        viewModel.deleteClient(clientId: client.id) { success in
            if success {
                dismiss()
            }
        }
    }
}
