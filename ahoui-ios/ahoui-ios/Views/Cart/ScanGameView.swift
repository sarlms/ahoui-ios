import SwiftUI

struct ScanGameView: View {
    @Binding var gameIdInput: String
    @ObservedObject var viewModel: CartViewModel

    var body: some View {
        VStack(spacing: 0) {
            Text("Scanner un article")
                .font(.custom("Poppins-SemiBold", size: 20))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
            VStack {
                TextField("ID du jeu (étiquette)", text: $gameIdInput)
                    .font(.custom("Poppins-LightItalic", size: 13))
                    .padding(.horizontal)
                    .frame(height: 35)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                
                Button(action: {
                    viewModel.addGameToCart(byId: gameIdInput)
                    gameIdInput = ""
                }) {
                    Text("AJOUTER")
                        .font(.custom("Poppins-Bold", size: 16))
                        .padding()
                        .frame(width: 110)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 10)
            }
            .padding()
            .frame(width: 340)
            .background(Color.white.opacity(0))
            .cornerRadius(20)
        }
    }
}
