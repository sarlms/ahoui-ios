import SwiftUI

struct CatalogueView: View {
    @ObservedObject var viewModel: DepositedGameViewModel
    @ObservedObject var sessionViewModel: SessionViewModel

    var body: some View {
        ZStack {
            Color(red: 1, green: 0.965, blue: 0.922)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Catalogue")
                    .font(.custom("Poppins-SemiBold", size: 25))
                    .foregroundColor(.black)
                    .padding(.top, 20)

                SearchBar(text: $viewModel.searchText)

                HStack {
                    Picker("Session", selection: $viewModel.selectedSessionId) {
                        Text("Toutes les sessions").tag(nil as String?)
                        ForEach(sessionViewModel.sessions) { session in
                            Text(session.name).tag(session.id as String?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 200)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))

                    Picker(selection: $viewModel.selectedSortOption, label: SortButton(title: "Trier par", action: {})) {
                        ForEach(DepositedGameViewModel.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 150)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                }
                .padding(.horizontal, 20)

                if viewModel.isLoading {
                    ProgressView().padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                } else {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(viewModel.filteredGames) { game in
                                NavigationLink(destination: CatalogueGameDetailView(viewModel: viewModel, gameId: game.id)) {
                                    GameCard(game: game)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchAllDepositedGames()
            sessionViewModel.loadSessions()
        }
    }
}


struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Rechercher le nom d’un jeu", text: $text)
                .padding(10)
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                .padding(.horizontal, 20)

            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
        }
    }
}

struct SortButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "play.fill")
                Text(title)
            }
            .font(.custom("Poppins", size: 14))
            .foregroundColor(.black)
            .padding(8)
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
        }
    }
}

struct GameCard: View {
    let game: DepositedGame

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: game.gameDescription.photoURL)) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 100, height: 100)
            .cornerRadius(10)

            Text(game.gameDescription.name)
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(width: 126)

            Text("\(game.salePrice, specifier: "%.0f")€")
                .font(.custom("Montserrat-SemiBold", size: 20))
                .foregroundColor(.black)
        }
        .padding()
        .frame(width: 154, height: 184)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 6)
    }
}
