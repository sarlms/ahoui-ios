import Foundation

/// Formats an ISO8601 date string into a human-readable format.
public func formatDate(_ dateString: String) -> String {
    let formatter = ISO8601DateFormatter()
    if let date = formatter.date(from: dateString) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return displayFormatter.string(from: date)
    }
    return dateString
}
