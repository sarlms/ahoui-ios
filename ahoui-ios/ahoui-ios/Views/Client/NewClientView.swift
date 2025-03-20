import SwiftUI

struct NewClientView: View {
    @EnvironmentObject var viewModel: ClientViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var address = ""

    var body: some View {
        NavigationStack {
            VStack {
                Text("Créer un client")
                    .font(.system(size: 22, weight: .bold))

                InputFieldNewClient(title: "Nom", text: $name, placeholder: "Nom du client")
                InputFieldNewClient(title: "Email", text: $email, placeholder: "Email")
                InputFieldNewClient(title: "Téléphone", text: $phone, placeholder: "Téléphone")
                InputFieldNewClient(title: "Adresse", text: $address, placeholder: "Adresse")

                Button(action: createClient) {
                    Text("Créer")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(15)
                }
                .padding()

                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Nouveau client")
        }
    }

    func createClient() {
        let newClient = Client(id: "", name: name, email: email, phone: phone, address: address) // Empty id
        viewModel.createClient(client: newClient)
        presentationMode.wrappedValue.dismiss()
    }

}
