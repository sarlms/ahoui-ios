import SwiftUI

struct HomeView: View {
    @State private var isMenuOpen = false
    @State private var countdown: String = ""
    @State private var timer: Timer? = nil
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var sessionViewModel = SessionViewModel() // ✅ Utilisation correcte du ViewModel

    var body: some View {
        ZStack {
            // Fond principal
            Color(red: 1, green: 0.965, blue: 0.922)
                .ignoresSafeArea()

            VStack {
                // Barre de navigation
                HStack {
                    Button(action: {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image("logoMENU")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                            .padding(.top, 50)
                    }
                    
                    Spacer()

                    Image("logoAHOUI")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .padding(.top, 50)

                    Spacer()
                    
                    Image("logoFLEUR")
                        .resizable()
                        .frame(width: 50, height: 40)
                        .padding(.trailing, 20)
                        .padding(.top, 40)
                }
                .frame(height: 110)
                .background(Color(red: 1, green: 0.965, blue: 0.922))
                .border(Color.black, width: 1)
                .ignoresSafeArea(edges: .top)

                Spacer()

                // 🔹 Affichage selon la session active ou à venir
                if let session = sessionViewModel.activeSession {
                    VStack {
                        Text("\(session.name) en cours !")
                            .font(.custom("Poppins-SemiBold", size: 24))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        Text("Rendez-vous à \(session.location)")
                            .font(.custom("Poppins-Light", size: 16))
                            .foregroundColor(.black)

                        Text("À vos marques... Prêts... Partez !!")
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(.black)
                    }
                    .padding()
                } else if let session = sessionViewModel.nextSession {
                    VStack {
                        Text("Prochaine session dans :")
                            .font(.custom("Poppins-Light", size: 18))
                            .foregroundColor(.black)

                        Text(countdown)
                            .font(.custom("Poppins-SemiBold", size: 38))
                            .foregroundColor(.black)

                        Text("\(session.name)")
                            .font(.custom("Poppins-Medium", size: 22))
                            .foregroundColor(.black)
                    }
                    .padding()
                } else {
                    Text("Rien de prévu pour l'instant...")
                        .font(.custom("Poppins-SemiBold", size: 24))
                        .foregroundColor(.black)
                }

                Image("logoMENU")
                    .resizable()
                    .frame(width: 213, height: 213)

                Spacer()

                Image("logoFLEUR")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            sessionViewModel.loadActiveSession() // ✅ Chargement de la session active
            sessionViewModel.loadNextSession()   // ✅ Chargement de la prochaine session
        }
        .onReceive(sessionViewModel.$nextSession) { session in
            if let session = session {
                startCountdown(to: session.startDate)
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
        .overlay(
            NavBarView(isMenuOpen: $isMenuOpen)
                .environmentObject(viewModel)
        )
    }

    // 🔹 Gestion du compte à rebours
    func startCountdown(to targetDate: String) {
        guard let targetDate = ISO8601DateFormatter().date(from: targetDate) else { return }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let now = Date()
            let timeLeft = targetDate.timeIntervalSince(now)

            if timeLeft <= 0 {
                timer?.invalidate()
                self.countdown = "00:00:00"
                return
            }

            let hours = Int(timeLeft) / 3600
            let minutes = (Int(timeLeft) % 3600) / 60
            let seconds = Int(timeLeft) % 60

            self.countdown = String(format: "%02dh %02dmin %02ds", hours, minutes, seconds)
        }
    }
}

#Preview {
    HomeView()
}
