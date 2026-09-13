import FeatherAdmin
import Foundation

public struct AdminEditUserIdentityFormInput: Decodable, Sendable, Equatable,
    Hashable
{

    public let name: String
    public let status: String
    public let roleIds: [String]?

    private enum CodingKeys: String, CodingKey {
        case name
        case status
        case roleIds = "roleIds[]"
    }

    var normalizedStatus: String {
        status.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}
