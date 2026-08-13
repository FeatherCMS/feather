import FeatherAdmin
import Foundation

public struct AdminAddAccountInvitationFormInput: Codable, Sendable, Equatable,
    Hashable
{

    public let email: String

    public init(email: String) {
        self.email = email
    }

    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
