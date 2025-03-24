import SwiftUI

struct NewSellerView: View {
    @EnvironmentObject var viewModel: SellerViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var amountOwed = ""

    var amountOwedDouble: Double {
        Double(amountOwed) ?? 0.0
    }

    var body: some View {
        ZStack {
            Color(red: 1, green: 0.965, blue: 0.922)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Nouveau vendeur")
                    .font(.custom("Poppins-SemiBold", size: 25))
                    .foregroundColor(.black)
                    .padding(.top, 30)

                Spacer(minLength: 20)

                VStack(alignment: .leading, spacing: 15) {
                    StyledInputField(title: "Nom", text: $name, placeholder: "Nom du vendeur")
                    StyledInputField(title: "Email", text: $email, placeholder: "Email")
                    StyledInputField(title: "Téléphone", text: $phone, placeholder: "Téléphone")
                    StyledInputField(title: "Montant dû (€)", text: $amountOwed, placeholder: "0")
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                .frame(width: 300)

                Spacer(minLength: 20)

                Button(action: createSeller) {
                    Text("Créer")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 120)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                }
                .disabled(name.isEmpty || email.isEmpty || phone.isEmpty)

                Spacer()
            }
            .padding()
        }
    }

    func createSeller() {
        let newSeller = Seller(
            id: UUID().uuidString,
            name: name,
            email: email,
            phone: phone,
            amountOwed: amountOwedDouble
        )
        viewModel.createSeller(seller: newSeller)
        presentationMode.wrappedValue.dismiss()
    }
}

