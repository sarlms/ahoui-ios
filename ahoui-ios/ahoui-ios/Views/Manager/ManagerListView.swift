import SwiftUI

struct ManagerListView: View {
    @StateObject private var viewModel = ManagerViewModel()
    @State private var searchText = ""
    @State private var isPresentingNewManagerView = false
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var isMenuOpen = false

    var filteredManagers: [Manager] {
        if searchText.isEmpty {
            return viewModel.managers
        } else {
            return viewModel.managers.filter {
                $0.firstName.lowercased().contains(searchText.lowercased()) ||
                $0.lastName.lowercased().contains(searchText.lowercased()) ||
                $0.email.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()

                VStack {
                    // Title
                    Text("Liste des managers")
                        .font(.custom("Poppins-SemiBold", size: 25))
                        .foregroundColor(.black)
                        .padding(.top, 160)

                    Spacer(minLength: 20)

                    // Create Manager Button
                    Button(action: {
                        isPresentingNewManagerView = true
                    }) {
                        Text("Créer un nouveau manager")
                            .font(.custom("Poppins-Medium", size: 13))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 67 / 255, green: 157 / 255, blue: 239 / 255))
                            .padding()
                            .frame(width: 220, height: 40)
                            .background(Color(red: 1, green: 0.985, blue: 0.962))
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 67 / 255, green: 157 / 255, blue: 239 / 255), lineWidth: 1))
                    }
                    .padding(.horizontal, 80)
                    .sheet(isPresented: $isPresentingNewManagerView) {
                        NewManagerView(viewModel: viewModel)
                    }

                    Spacer(minLength: 20)

                    // Search Bar
                    HStack {
                        TextField("", text: $searchText, prompt: Text("Rechercher un manager").italic().font(.custom("Poppins-Italic", size: 12)))
                            .padding(8)
                            .background(Color(red: 1, green: 0.985, blue: 0.962))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)

                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 50)

                    Spacer(minLength: 10)

                    // List of Managers
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            if filteredManagers.isEmpty {
                                Text("Aucun manager disponible")
                                    .font(.custom("Poppins", size: 13))
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(filteredManagers) { manager in
                                    ManagerCard(manager: manager)
                                        .padding(.horizontal, 40)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)

                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.custom("Poppins", size: 13))
                            .foregroundColor(.red)
                            .padding()
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)

                NavBarView(isMenuOpen: $isMenuOpen)
                    .environmentObject(navigationViewModel)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                Task {
                    await viewModel.fetchManagers()
                }
            }
        }
    }
}

struct ManagerCard: View {
    let manager: Manager

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(manager.firstName) \(manager.lastName)")
                .font(.custom("Poppins-SemiBold", size: 15))
                .foregroundColor(.black)

            InfoRow(label: "Email", value: manager.email)
            InfoRow(label: "Téléphone", value: manager.phone)
            InfoRow(label: "Adresse", value: manager.address)
            InfoRow(label: "Admin", value: manager.admin ? "Oui" : "Non")

            HStack {
                Spacer()
                NavigationLink(destination: EditManagerView(manager: manager)) {
                    Text("Éditer")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(Color(red: 67 / 255, green: 157 / 255, blue: 239 / 255))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(red: 67 / 255, green: 157 / 255, blue: 239 / 255)
, lineWidth: 1))
                }
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text("\(label) :")
                .font(.custom("Poppins-Bold", size: 13))
            Text(value)
                .font(.custom("Poppins-Light", size: 13))
        }
        .foregroundColor(.black)
    }
}
