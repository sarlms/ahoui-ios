import SwiftUI

struct CatalogueView: View {
    @ObservedObject var viewModel: DepositedGameViewModel
    @ObservedObject var sessionViewModel: SessionViewModel
    
    @State private var shouldNavigate = false
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var isMenuOpen = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Text("Catalogue")
                        .font(.custom("Poppins-SemiBold", size: 25))
                        .foregroundColor(.black)
                        .padding(.top, 40)
                    
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
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 20),
                                GridItem(.flexible(), spacing: 20)
                            ], spacing: 20) {
                                ForEach(viewModel.filteredGames) { game in
                                    NavigationLink(destination: CatalogueGameDetailView(viewModel: viewModel, gameId: game.id)) {
                                        GameCard(game: game)
                                    }
                                }
                            }
                            .padding(.horizontal, 0)
                            .frame(maxWidth: .infinity)
                        }

                    }
                    
                    Spacer()
                }
                .frame(maxWidth: 300)
                .padding(.horizontal, 45)
                .padding(.top, 30)
                .navigationBarBackButtonHidden(true)
                .overlay(
                    NavBarView(isMenuOpen: $isMenuOpen)
                        .environmentObject(viewModel)
                )
                .onAppear {
                    viewModel.fetchAllDepositedGames()
                    sessionViewModel.loadSessions()
                }
                
            }
        }
    }
    
    
    struct SearchBar: View {
        @Binding var text: String
        
        var body: some View {
            HStack {
                TextField("Rechercher le nom d’un jeu", text: $text)
                    .padding(8)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .padding(.horizontal, 1)
                    .font(.custom("Poppins-LightItalic", size: 13))
                
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
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 14))

                    Text(title)
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.black)
                }
                .frame(height: 29)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle()) // ✅ empêche le style bleu par défaut
        }
    }


    
    struct GameCard: View {
        let game: DepositedGame
        
        var body: some View {
            VStack {
                AsyncImage(url: URL(string: game.gameDescription.photoURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit) // ✅ Garde les proportions sans crop
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 100, height: 100)
                .background(Color.white)
                .cornerRadius(10)
                .clipped()
                
                Text(game.gameDescription.name)
                    .font(.custom("Poppins-SemiBold", size: 11))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity)

                
                Text("\(game.salePrice, specifier: "%.0f")€")
                    .font(.custom("Poppins-SemiBold", size: 20))
                    .foregroundColor(.black)
            }
            .padding()
            .frame(width: 150, height: 180)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
}
