import SwiftUI

struct NewClientView: View {
    @EnvironmentObject var viewModel: ClientViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var address = ""

    var body: some View {
        ZStack {
            Color(red: 1, green: 0.965, blue: 0.922)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Nouveau client")
                    .font(.custom("Poppins-SemiBold", size: 25))
                    .foregroundColor(.black)
                    .padding(.top, 30)

                Spacer(minLength: 20)

                VStack(alignment: .leading, spacing: 15) {
                    StyledInputField(title: "Nom", text: $name, placeholder: "Nom du client")
                    StyledInputField(title: "Email", text: $email, placeholder: "Email")
                    StyledInputField(title: "Téléphone", text: $phone, placeholder: "Téléphone")
                    StyledInputField(title: "Adresse", text: $address, placeholder: "Adresse")
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                .frame(width: 300)

                Spacer(minLength: 20)

                Button(action: createClient) {
                    Text("Créer")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 120)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                }
                .disabled(name.isEmpty || email.isEmpty || phone.isEmpty || address.isEmpty)

                Spacer()
            }
            .padding()
        }
    }

    func createClient() {
        let newClient = Client(id: "", name: name, email: email, phone: phone, address: address)
        viewModel.createClient(client: newClient)
        presentationMode.wrappedValue.dismiss()
    }
}

struct StyledInputField: View {
    let title: String
    @Binding var text: String
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(.black)

            TextField(placeholder, text: $text)
                .font(.custom("Poppins", size: 13))
                .padding(10)
                .background(Color.white.opacity(0.5))
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
        }
        .padding(.horizontal, 20)
    }
}

