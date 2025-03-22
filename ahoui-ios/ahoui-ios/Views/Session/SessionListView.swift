import SwiftUI

struct SessionListView: View {
    @StateObject private var viewModel = SessionListViewModel()
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var isMenuOpen = false
    private let sessionService = SessionService()
    

    var body: some View {
        NavigationStack { // ✅ Déplacer le NavigationStack ici
            ScrollView {
                VStack(spacing: 16) {
                    Spacer()
                    Spacer()
                    Text("Liste des Sessions")
                        .font(.custom("Poppins-SemiBold", size: 25))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    ForEach(viewModel.sessions) { session in
                        SessionCardView(session: session, sessionService: sessionService)
                    }
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .background(Color(red: 1, green: 0.965, blue: 0.922))
            .onAppear {
                viewModel.loadSessions()
            }
            .overlay(
                NavBarView(isMenuOpen: $isMenuOpen)
                    .environmentObject(viewModel)
            )
        }
    }
}
