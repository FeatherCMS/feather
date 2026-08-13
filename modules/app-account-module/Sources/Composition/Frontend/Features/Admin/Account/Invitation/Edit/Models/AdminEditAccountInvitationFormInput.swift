import FeatherAdmin
import Foundation

public struct AdminEditAccountInvitationFormInput: Codable, Sendable, Equatable,
    Hashable
{

    public let email: String

    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
