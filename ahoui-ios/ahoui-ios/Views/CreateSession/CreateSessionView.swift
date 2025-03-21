import SwiftUI

struct CreateSessionView: View {
    @StateObject private var viewModel = CreateSessionViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel // Pour récupérer le token

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Créer une session")
                    .font(.system(size: 25, weight: .semibold))
                    .padding(.bottom, 10)

                TextField("Nom de la session", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Adresse du lieu", text: $viewModel.location)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Description", text: $viewModel.description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                HStack {
                    DatePicker("Date début", selection: $viewModel.startDate, displayedComponents: .date)
                    Text("-")
                    DatePicker("Date fin", selection: $viewModel.endDate, displayedComponents: .date)
                }

                HStack {
                    DatePicker("Heure début", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    Text("-")
                    DatePicker("Heure fin", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                }

                TextField("Frais de dépôt", text: $viewModel.depositFee)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                HStack {
                    TextField("Réduction dépôt", text: $viewModel.depositFeeDiscount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("%")
                }
                Text("À partir de 30$ de frais de dépôt")
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack {
                    TextField("Commission", text: $viewModel.saleComission)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("%")
                }

                if let successMessage = viewModel.successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .font(.headline)
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.headline)
                }

                Button(action: {
                    if let authToken = UserDefaults.standard.string(forKey: "token") {
                        viewModel.createSession(authToken: authToken)
                    }
                }) {
                    Text("CRÉER")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
