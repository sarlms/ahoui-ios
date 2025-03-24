import SwiftUI

struct TreasuryView: View {
    // MARK: - Services
    private let transactionService = TransactionService()
    private let refundService = RefundService()
    private let depositFeePaymentService = DepositFeePaymentService()
    @StateObject private var authViewModel = AuthViewModel()

    // MARK: - Données
    @State private var transactions: [TransactionList] = []
    @State private var refunds: [Refund] = []
    @State private var depositFees: [DepositFeePayment] = []
    @State private var allOperations: [TreasuryItem] = []

    // MARK: - UI State
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedOperation: String = "Toutes les opérations"

    let operations = ["Toutes les opérations", "Vente", "Remboursement", "Frais de dépôt"]
    
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @State private var isMenuOpen = false

    // MARK: - Revenus
    var totalRevenue: Double {
        let totalTransactions = transactions.reduce(0) { $0 + $1.label.salePrice }
        let totalDepositFees = depositFees.reduce(0) { $0 + $1.depositFeePayed }
        let totalRefunds = refunds.reduce(0) { $0 + $1.refundAmount }
        return totalTransactions + totalDepositFees - totalRefunds
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1, green: 0.965, blue: 0.922)
                    .ignoresSafeArea()
                VStack {
                    Spacer(minLength: 140)
                    
                    Text("Trésorerie globale")
                        .font(.custom("Poppins-SemiBold", size: 25))
                        .padding(.top, 20)
                    
                    Text("Chiffre d’affaire : €\(totalRevenue, specifier: "%.2f")")
                        .font(.custom("Poppins-SemiBold", size: 20))
                        .foregroundColor(.green)
                    
                    // MARK: - Filtres
                    HStack {
                        Picker("Opération", selection: $selectedOperation) {
                            ForEach(operations, id: \.self) { operation in
                                Text(operation)
                                    .font(.custom("Poppins-Light", size: 11))
                                    .tag(operation)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black, lineWidth: 0.5)
                        )
                    }
                    .padding(.top, 10)
                    
                    // MARK: - Liste des opérations
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            let filteredAndSorted = allOperations
                                .filter { item in
                                    selectedOperation == "Toutes les opérations" || item.type == selectedOperation
                                }
                                .sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }

                            if filteredAndSorted.isEmpty {
                                Text("Aucune opération trouvée.")
                                    .font(.custom("Poppins-SemiBold", size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            } else {
                                ForEach(filteredAndSorted) { item in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(dateFormatted(item.date ?? Date()))
                                            .font(.custom("Poppins-SemiBold", size: 13))
                                            .foregroundColor(.gray)
                                            .padding(.leading, 10)

                                        switch item {
                                        case .transaction(let t):
                                            TransactionCardTreasury(transaction: t)
                                        case .refund(let r):
                                            RefundCardTreasury(refund: r)
                                        case .deposit(let d):
                                            DepositFeePaymentCardTreasury(payment: d)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // MARK: - Message d'erreur
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .onAppear {
                    fetchData()
                }
                NavBarView(isMenuOpen: $isMenuOpen)
                    .environmentObject(navigationViewModel)
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    // MARK: - Fetch
    private func fetchData() {
        isLoading = true
        allOperations = []

        guard let token = authViewModel.authToken ?? UserDefaults.standard.string(forKey: "token") else {
            self.errorMessage = "Aucun token d'authentification"
            isLoading = false
            return
        }

        // Transactions
        Task {
            do {
                let fetchedTransactions = try await transactionService.fetchAllTransactions()
                self.transactions = fetchedTransactions
                let ops = fetchedTransactions.map { TreasuryItem.transaction($0) }
                DispatchQueue.main.async {
                    self.allOperations += ops
                    self.sortAll()
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Erreur lors du chargement des ventes : \(error.localizedDescription)"
                }
            }
        }

        // Refunds
        refundService.fetchAllRefunds { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRefunds):
                    self.refunds = fetchedRefunds
                    let ops = fetchedRefunds.map { TreasuryItem.refund($0) }
                    self.allOperations += ops
                    self.sortAll()
                case .failure(let error):
                    self.errorMessage = "Erreur lors du chargement des remboursements : \(error.localizedDescription)"
                }
            }
        }

        // Deposit fees
        depositFeePaymentService.fetchAllPayments(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedPayments):
                    self.depositFees = fetchedPayments
                    let ops = fetchedPayments.map { TreasuryItem.deposit($0) }
                    self.allOperations += ops
                    self.sortAll()
                case .failure(let error):
                    self.errorMessage = "Erreur lors du chargement des frais de dépôt : \(error.localizedDescription)"
                }
            }
        }

        isLoading = false
    }

    private func sortAll() {
        self.allOperations.sort { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
    }
}


// MARK: - Modèle typé d'opération unifiée
enum TreasuryItem: Identifiable {
    case transaction(TransactionList)
    case refund(Refund)
    case deposit(DepositFeePayment)

    var id: String {
        switch self {
        case .transaction(let t): return "T-\(t.id)"
        case .refund(let r): return "R-\(r.id)"
        case .deposit(let d): return "D-\(d.id)"
        }
    }

    var date: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let parsedDate: Date?
        switch self {
        case .transaction(let t):
            parsedDate = formatter.date(from: t.transactionDate)
            if parsedDate == nil { print("⛔️ transaction date parsing failed: \(t.transactionDate)") }
            return parsedDate
        case .refund(let r):
            parsedDate = formatter.date(from: r.refundDate)
            if parsedDate == nil { print("⛔️ refund date parsing failed: \(r.refundDate)") }
            return parsedDate
        case .deposit(let d):
            parsedDate = formatter.date(from: d.depositDate)
            if parsedDate == nil { print("⛔️ deposit date parsing failed: \(d.depositDate)") }
            return parsedDate
        }
    }


    var type: String {
        switch self {
        case .transaction: return "Vente"
        case .refund: return "Remboursement"
        case .deposit: return "Frais de dépôt"
        }
    }

    var sessionName: String {
        switch self {
        case .transaction(let t): return t.session.name
        case .refund(let r): return r.sessionId?.name ?? ""
        case .deposit(let d): return d.sessionId?.name ?? ""
        }
    }
}
