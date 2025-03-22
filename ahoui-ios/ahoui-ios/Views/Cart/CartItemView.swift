import SwiftUI

struct CartItemView: View {
    let game: DepositedGame
    @ObservedObject var viewModel: CartViewModel

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: game.gameDescription.photoURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(game.gameDescription.name)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .font(.headline)
                Text("Éditeur: \(game.gameDescription.publisher)")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(game.salePrice, specifier: "%.2f") €")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .font(.headline)
                    .foregroundColor(.black)
            }

            Spacer()

            Button(action: {
                viewModel.removeFromCart(game: game)
            }) {
                Image(systemName: "trash").foregroundColor(.red)
            }
        }
        .background(Color.white.opacity(0))
        .cornerRadius(10)
        .padding()
    }
}
