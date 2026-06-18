import Foundation

struct AdminEditUserInvitationFormInput: Codable, Sendable, Equatable, Hashable
{

    let email: String

    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
