import SwiftUI

struct SessionListView: View {
    @StateObject private var viewModel = SessionListViewModel()
    private let sessionService = SessionService()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Liste des Sessions")
                        .font(.system(size: 25, weight: .semibold))
                        .padding(.top, 20)

                    ForEach(viewModel.sessions) { session in
                        SessionCardView(session: session, sessionService: sessionService)
                    }
                }
                .padding()
            }
            .background(Color(red: 1, green: 0.965, blue: 0.922))
            .onAppear {
                viewModel.loadSessions()
            }
        }
    }
}
