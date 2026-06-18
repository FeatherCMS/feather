import Foundation

struct AdminStatusActionFormInput: Codable, Sendable, Equatable, Hashable {
    let returnTo: String?
    let status: String

    var normalizedReturnTo: String? {
        let trimmed = returnTo?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let trimmed, trimmed.hasPrefix("/admin/") else {
            return nil
        }
        return trimmed
    }

    var normalizedStatus: String {
        status
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
