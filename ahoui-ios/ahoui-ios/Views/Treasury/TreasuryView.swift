import SwiftUI

struct TreasuryView: View {
    // Services for fetching data directly
    private let transactionService = TransactionService()
    private let refundService = RefundService()
    private let depositFeePaymentService = DepositFeePaymentService()
    @StateObject private var authViewModel = AuthViewModel()

    // Observed state variables
    @State private var transactions: [TransactionList] = []
    @State private var refunds: [Refund] = []
    @State private var depositFees: [DepositFeePayment] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    @State private var selectedSession: String = "Toutes les sessions"
    @State private var selectedOperation: String = "Toutes les opérations"

    let sessions = ["Toutes les sessions", "Session de février", "Session de mars"]
    let operations = ["Toutes les opérations", "Vente", "Remboursement", "Frais de dépôt"]

    var totalRevenue: Double {
        let totalTransactions = transactions.reduce(0) { $0 + $1.label.salePrice }
        let totalDepositFees = depositFees.reduce(0) { $0 + $1.depositFeePayed }
        let totalRefunds = refunds.reduce(0) { $0 + $1.refundAmount }

        return totalTransactions + totalDepositFees - totalRefunds
    }

    var body: some View {
        VStack {
            Text("Trésorerie globale")
                .font(.system(size: 25, weight: .semibold))
                .padding(.top, 20)

            Text("Chiffre d’affaire : €\(totalRevenue, specifier: "%.2f")")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.green)

            // Filters
            HStack {
                Picker("Session", selection: $selectedSession) {
                    ForEach(sessions, id: \.self) { session in
                        Text(session).tag(session)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))

                Picker("Opération", selection: $selectedOperation) {
                    ForEach(operations, id: \.self) { operation in
                        Text(operation).tag(operation)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            }

            // Transaction List
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(transactions.filter { shouldDisplayTransaction($0) }, id: \.id) { transaction in
                        TransactionCard(transaction: transaction)
                    }

                    ForEach(refunds.filter { shouldDisplayRefund($0) }, id: \.id) { refund in
                        RefundCardTreasury(refund: refund)
                    }

                    ForEach(depositFees.filter { shouldDisplayDepositFee($0) }, id: \.id) { deposit in
                        DepositFeePaymentCardTreasury(payment: deposit)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            fetchData()
        }
    }

    // Fetching data using services directly
    private func fetchData() {
        isLoading = true
        
        // 🔹 Try to get the token safely
        guard let token = authViewModel.authToken ?? UserDefaults.standard.string(forKey: "token") else {
            self.errorMessage = "No authentication token found"
            isLoading = false
            return
        }

        // 🔹 Fetch Transactions
        Task {
            do {
                let fetchedTransactions = try await transactionService.fetchAllTransactions()
                print("transactions: ", fetchedTransactions)
                DispatchQueue.main.async { self.transactions = fetchedTransactions }
            } catch {
                DispatchQueue.main.async { self.errorMessage = "Error fetching transactions: \(error.localizedDescription)" }
            }
        }

        // 🔹 Fetch Refunds
        refundService.fetchAllRefunds { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRefunds):
                    self.refunds = fetchedRefunds
                    print("✅ Refunds successfully fetched:", fetchedRefunds)
                case .failure(let error):
                    self.errorMessage = "Error fetching refunds: \(error.localizedDescription)"
                    print("❌ Failed to fetch refunds:", error.localizedDescription)
                }
            }
        }


        // 🔹 Fetch Deposit Fee Payments (✅ Pass Unwrapped Token)
        depositFeePaymentService.fetchAllPayments(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedPayments):
                    self.depositFees = fetchedPayments
                case .failure(let error):
                    self.errorMessage = "Error fetching deposit fee payments: \(error.localizedDescription)"
                }
            }
        }

        isLoading = false
    }


    // Filter logic
    private func shouldDisplayTransaction(_ transaction: TransactionList) -> Bool {
        (selectedSession == "Toutes les sessions" || transaction.session.name == selectedSession) &&
        (selectedOperation == "Toutes les opérations" || selectedOperation == "Vente")
    }

    private func shouldDisplayRefund(_ refund: Refund) -> Bool {
        let sessionName = refund.sessionId?.name ?? "Unknown Session"  // ✅ Handle nil case
        return (selectedSession == "Toutes les sessions" || sessionName == selectedSession) &&
               (selectedOperation == "Toutes les opérations" || selectedOperation == "Remboursement")
    }

    private func shouldDisplayDepositFee(_ payment: DepositFeePayment) -> Bool {
        return (selectedSession == "Toutes les sessions" || payment.sessionId?.name == selectedSession) &&
               (selectedOperation == "Toutes les opérations" || selectedOperation == "Frais de dépôt")
    }
}
