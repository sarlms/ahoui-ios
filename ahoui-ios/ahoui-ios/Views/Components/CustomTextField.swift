import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        ZStack(alignment: .trailing) {
            if isSecure {
                Group {
                    if isPasswordVisible {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .font(.custom("Poppins-Italic", size: 16))
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .frame(width: 250, height: 50)
                .autocapitalization(.none)
                .disableAutocorrection(true)

                // 👁️‍🗨️ Bouton pour afficher/masquer
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.trailing, 12)
                }
            } else {
                TextField(placeholder, text: $text)
                    .font(.custom("Poppins-Italic", size: 16))
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .frame(width: 250, height: 50)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
    }
}
