import Foundation

struct AdminAddUserAccountFormInput: Codable, Sendable, Equatable, Hashable {

    let email: String
    let password: String

    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
