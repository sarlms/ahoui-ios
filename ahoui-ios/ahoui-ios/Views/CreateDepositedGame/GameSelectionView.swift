import SwiftUI

struct GameSelectionView: View {
    @Binding var game: GameDeposited
    @ObservedObject var gameDescriptionViewModel: GameDescriptionViewModel
    @State private var showGameDropdown = false
    @State private var localSearchText = ""
    var filteredNames: [String] {
        if localSearchText.isEmpty {
            return gameDescriptionViewModel.uniqueGameNames
        } else {
            return gameDescriptionViewModel.uniqueGameNames.filter {
                $0.lowercased().contains(localSearchText.lowercased())
            }
        }
    }


    var removeAction: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Text("Jeu")
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)

                VStack(alignment: .leading, spacing: 10) {
                    // 🔹 Nom du jeu
                    Text("Nom du jeu")
                        .font(.custom("Poppins-SemiBold", size: 15))

                    ZStack(alignment: .trailing) {
                        TextField("Tapez le nom du jeu", text: $localSearchText, onEditingChanged: { isEditing in
                            showGameDropdown = isEditing
                        })
                        .onChange(of: localSearchText) { newValue in
                            game.name = newValue
                        }

                        .font(.custom("Poppins-LightItalic", size: 13))
                        .padding(.horizontal)
                        .frame(height: 35)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))

                        Image(systemName: "chevron.down")
                            .padding(.trailing, 10)
                            .foregroundColor(.black)
                    }

                    if showGameDropdown && !filteredNames.isEmpty {
                        VStack(spacing: 5) {
                            ForEach(filteredNames, id: \.self) { name in
                                Text(name)
                                    .font(.custom("Poppins-LightItalic", size: 13))
                                    .padding(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(4)
                                    .onTapGesture {
                                        localSearchText = name
                                        game.name = name
                                        showGameDropdown = false
                                        gameDescriptionViewModel.fetchGameByName(name: name)
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
                    }

                    // 🔹 Prix de vente
                    Text("Prix de vente")
                        .font(.custom("Poppins-SemiBold", size: 15))

                    TextField("0", text: $game.salePrice)
                        .keyboardType(.decimalPad)
                        .font(.custom("Poppins-LightItalic", size: 13))
                        .padding(.horizontal)
                        .frame(height: 35)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(4)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))

                    // 🔹 Toggle
                    HStack {
                        Text("Disponible à la vente ?")
                            .font(.custom("Poppins-SemiBold", size: 15))
                        Spacer()
                        Toggle(isOn: $game.isForSale) {
                            EmptyView()
                        }
                        .labelsHidden()
                        .scaleEffect(0.8)
                    }

                    Spacer()
                    // 🔹 Poubelle
                    HStack {
                        Spacer()
                        Button(action: {
                            removeAction()
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 24))
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                .frame(width: 340)
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
