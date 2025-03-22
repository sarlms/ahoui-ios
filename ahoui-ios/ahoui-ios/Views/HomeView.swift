import SwiftUI

struct HomeView: View {
    @State private var isMenuOpen = false
    @State private var countdown: String = ""
    @State private var timer: Timer? = nil
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @StateObject private var sessionViewModel = SessionViewModel()

    var body: some View {
        NavigationStack { // ✅ Déplacer le NavigationStack ici
            ZStack {
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()

                VStack {

                    Spacer()
                    Spacer()
                    Spacer()

                    if let session = sessionViewModel.activeSession {
                        VStack {
                            HStack{
                                Text("La session")
                                    .font(.custom("Poppins-Light", size: 18))
                                    .foregroundColor(.black)
                                Text("\(session.name)")
                                    .font(.custom("Poppins-Bold", size: 18))
                                    .foregroundColor(.black)
                                Text("est ouverte !")
                                    .font(.custom("Poppins-Light", size: 18))
                                    .foregroundColor(.black)
                            }
                            Text("FONCEZ !!!")
                                .font(.custom("Poppins-Bold", size: 35))
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
                    
                    if let session = sessionViewModel.activeSession {
                        VStack {
                            Text("Rendez-vous au")
                                .font(.custom("Poppins-Light", size: 16))
                                .foregroundColor(.black)
                            Text("\(session.location)")
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(.black)
                        }
                        .padding()
                    }

                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Image("logoBIGFLEUR")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                        .padding(.bottom, -35)
                }
            }
            .onAppear {
                sessionViewModel.loadActiveSession()
                sessionViewModel.loadNextSession()
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
        .navigationBarBackButtonHidden(true) 
    }

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


