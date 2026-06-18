import Foundation

struct AdminEditUserAccountFormInput: Codable, Sendable, Equatable, Hashable {

    let email: String
    let password: String
    let roleIds: [String]?

    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedPassword: String? {
        let value = password.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}
