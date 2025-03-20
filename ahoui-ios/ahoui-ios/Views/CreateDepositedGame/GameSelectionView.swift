import SwiftUI

struct GameSelectionView: View {
    @Binding var game: GameDeposited
    @ObservedObject var gameDescriptionViewModel: GameDescriptionViewModel
    @State private var showGameDropdown = false

    var removeAction: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Nom du jeu")
                    .font(.custom("Poppins-SemiBold", size: 12))

                HStack {
                    TextField("Tapez le nom du jeu", text: $game.name, onEditingChanged: { isEditing in
                        showGameDropdown = isEditing
                    })
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .frame(width: 200)
                }

                if showGameDropdown && !gameDescriptionViewModel.filteredNames.isEmpty {
                    ScrollView {
                        VStack(spacing: 5) {
                            ForEach(gameDescriptionViewModel.filteredNames, id: \.self) { name in
                                Text(name)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        game.name = name
                                        showGameDropdown = false
                                    }
                            }
                        }
                        .frame(width: 250)
                    }
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                }

                Text("Prix de vente")
                    .font(.custom("Poppins-SemiBold", size: 12))

                TextField("0", text: $game.salePrice)
                    .keyboardType(.decimalPad)
                    .padding()
                    .frame(width: 80)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))

                Toggle("Disponible à la vente ?", isOn: $game.isForSale)
                    .font(.custom("Poppins-Regular", size: 12))

                Button(action: {
                    removeAction()
                }) {
                    Text("SUPPRIMER")
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .padding()
            .frame(width: 284)
            .background(Color.white.opacity(0.5))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
        }
    }
}
