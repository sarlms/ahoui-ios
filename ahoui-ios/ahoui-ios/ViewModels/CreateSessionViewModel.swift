import Foundation

class CreateSessionViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var location: String = ""
    @Published var description: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date()
    @Published var depositFee: String = ""
    @Published var depositFeeDiscount: String = ""
    @Published var saleComission: String = ""

    @Published var successMessage: String?
    @Published var errorMessage: String?

    private let sessionService = SessionService()

    func createSession(authToken: String) {
        guard let depositFeeValue = Double(depositFee),
              let depositFeeDiscountValue = Double(depositFeeDiscount),
              let saleComissionValue = Double(saleComission) else {
            errorMessage = "Veuillez entrer des valeurs numériques valides."
            return
        }

        // Fusion des dates et heures
        let formattedStartDate = sessionService.mergeDateAndTime(date: startDate, time: startTime)
        let formattedEndDate = sessionService.mergeDateAndTime(date: endDate, time: endTime)

        let sessionData: [String: Any] = [
            "name": name,
            "location": location,
            "description": description,
            "startDate": formattedStartDate,
            "endDate": formattedEndDate,
            "depositFee": depositFeeValue,
            "depositFeeDiscount": depositFeeDiscountValue,
            "saleComission": saleComissionValue,
            "managerId": UserDefaults.standard.string(forKey: "managerId") ?? ""
        ]

        sessionService.createSession(sessionData: sessionData, authToken: authToken) { success, message in
            DispatchQueue.main.async {
                if success {
                    self.successMessage = "Session créée avec succès !"
                    self.clearFields()
                } else {
                    self.errorMessage = message
                }
            }
        }
    }

    private func clearFields() {
        name = ""
        location = ""
        description = ""
        startDate = Date()
        endDate = Date()
        startTime = Date()
        endTime = Date()
        depositFee = ""
        depositFeeDiscount = ""
        saleComission = ""
    }
}
