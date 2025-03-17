import SwiftUI

struct NewSellerView: View {
    @EnvironmentObject var viewModel: SellerViewModel
    @Environment(\.presentationMode) var presentationMode // ✅ Allows navigation back

    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var amountOwed = ""

    var amountOwedDouble: Double {
        Double(amountOwed) ?? 0.0
    }

    var body: some View {
        VStack {
            Text("Nouveau vendeur")
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(.black)

            VStack {
                InputField(title: "Nom", text: $name, placeholder: "Entrez le nom")
                InputField(title: "Email", text: $email, placeholder: "Entrez l’email")
                InputField(title: "Numéro de téléphone", text: $phone, placeholder: "Entrez le numéro de téléphone")
                InputField(title: "Montant dû (€)", text: $amountOwed, placeholder: "0")

                Button(action: {
                    let newSeller = Seller(
                        id: UUID().uuidString, // ⚠️ This should be removed if the backend generates the ID
                        name: name,
                        email: email,
                        phone: phone,
                        amountOwed: amountOwedDouble
                    )
                    viewModel.createSeller(seller: newSeller)
                    presentationMode.wrappedValue.dismiss() // ✅ Navigate back to SellerListView
                }) {
                    Text("Créer")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 80)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
                }
            }
            .padding()
            .frame(width: 284, height: 317)
            .background(Color.white.opacity(0.5))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
        }
        .padding()
    }
}


struct InputField: View {
    var title: String
    @Binding var text: String
    var placeholder: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.black)
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 5)
        }
    }
}
