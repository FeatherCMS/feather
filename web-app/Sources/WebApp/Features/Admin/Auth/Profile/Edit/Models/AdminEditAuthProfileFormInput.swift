import Foundation

struct AdminEditAuthProfileFormInput: Codable, Sendable, Equatable, Hashable {

    let email: String
    let password: String

    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedPassword: String? {
        let value = password.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}
