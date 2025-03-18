import SwiftUI

struct RefundView: View {
    let refund: Refund

    // ✅ Format refund date
    var formattedDate: String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"

        if let date = inputFormatter.date(from: refund.refundDate) {
            return outputFormatter.string(from: date)
        }
        return refund.refundDate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // ✅ ID
            //Text("ID : \(refund.id)")
                //.font(.system(size: 14, weight: .bold))
                //.foregroundColor(.black)

            // ✅ Date
            Text("**Date :** \(formattedDate)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // ✅ Amount
            Text("**Montant :** \(String(format: "%.2f", refund.refundAmount))€")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)

            // ✅ Session Name
            //Text("**Session :** \(refund.session.name)")
                //.font(.system(size: 12, weight: .bold))
                //.foregroundColor(.black)

            // ✅ Manager Name
            //Text("**Manager en charge :** \(refund.manager.email)") // ✅ Only email available from API
               // .font(.system(size: 12, weight: .bold))
                //.foregroundColor(.black)
        }
        .padding()
        .frame(width: 320)
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
    }
}
