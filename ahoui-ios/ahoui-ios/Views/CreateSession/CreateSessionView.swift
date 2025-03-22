import SwiftUI

struct CreateSessionView: View {
    @StateObject private var viewModel = CreateSessionViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var isMenuOpen = false
    @State private var shouldNavigate = false

    var body: some View {
        NavigationStack {
            ZStack {
                // ✅ Fond beige clair
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()
                
                Spacer()
                VStack(spacing: 16) {
                    Text("Créer une session")
                        .font(.custom("Poppins-Bold", size: 25))
                        .foregroundColor(.black)
                        .padding(.top, 30)
                    
                    Group {
                        customTextField("Nom de la session", text: $viewModel.name)
                        customTextField("Adresse du lieu", text: $viewModel.location)
                        customTextField("Description", text: $viewModel.description)
                    }
                    
                    HStack(spacing: 10) {
                        customDateField("Date début", date: $viewModel.startDate)
                        Text("-")
                        customDateField("Date fin", date: $viewModel.endDate)
                    }
                    
                    HStack(spacing: 10) {
                        customTimeField("Heure début", time: $viewModel.startTime)
                        Text("-")
                        customTimeField("Heure fin", time: $viewModel.endTime)
                    }
                    
                    customTextField("Frais de dépôt", text: $viewModel.depositFee, keyboard: .decimalPad)
                    
                    HStack {
                        customTextField("Réduction dépôt", text: $viewModel.depositFeeDiscount, keyboard: .decimalPad)
                        Text("%")
                            .font(.custom("Poppins-Medium", size: 17))
                            .foregroundColor(.black)
                    }
                    
                    Text("A partir de 30$ de frais de dépôt")
                        .font(.custom("Poppins-LightItalic", size: 13))
                        .foregroundColor(.black)
                        .padding(.leading, 5)
                    
                    HStack {
                        customTextField("Comission", text: $viewModel.saleComission, keyboard: .decimalPad)
                        Text("%")
                            .font(.custom("Poppins-Medium", size: 17))
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        if let token = UserDefaults.standard.string(forKey: "token") {
                            viewModel.createSession(authToken: token)
                            shouldNavigate = true
                        }
                    }) {
                        Text("CRÉER")
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 49)
                            .background(Color(red: 0.05, green: 0.61, blue: 0.043))
                            .cornerRadius(15)
                    }
                    .padding(.top, 20)
                    .navigationDestination(isPresented: $shouldNavigate) {
                        SessionListView()
                    }
                    
                }
                .padding(.horizontal, 55)
                .navigationBarBackButtonHidden(true)
                .overlay(
                    NavBarView(isMenuOpen: $isMenuOpen)
                        .environmentObject(viewModel)
                )
            }
        }
    }

    func customTextField(_ placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        TextField(placeholder, text: text)
            .font(.custom("Poppins-LightItalic", size: 15))
            .padding(.horizontal)
            .frame(height: 42)
            .keyboardType(keyboard)
            .background(Color.white.opacity(0.5))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black, lineWidth: 1)
            )
    }

    func customDateField(_ label: String, date: Binding<Date>) -> some View {
        DatePicker("", selection: date, displayedComponents: .date)
            .labelsHidden()
            .frame(width: 127, height: 43)
            .background(Color.white.opacity(0.5))
            .cornerRadius(4)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
    }

    func customTimeField(_ label: String, time: Binding<Date>) -> some View {
        DatePicker("", selection: time, displayedComponents: .hourAndMinute)
            .labelsHidden()
            .frame(width: 127, height: 42)
            .background(Color.white.opacity(0.5))
            .cornerRadius(4)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
    }
}
