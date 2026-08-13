import FeatherAdmin
import Foundation

public struct AdminEditUserIdentityFormInput: Codable, Sendable, Equatable,
    Hashable
{

    public let status: String
    public let roleIds: [String]?

    var normalizedStatus: String {
        status.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
