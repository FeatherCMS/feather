import FeatherAdmin
import Foundation

public struct AdminAddUserIdentityFormInput: Decodable, Sendable, Equatable,
    Hashable
{

    public let name: String
    public let status: String
    public let roleIds: [String]?

    private enum CodingKeys: String, CodingKey {
        case name
        case status
        // URL-encoded array fields named `roleIds[]` decode as `roleIds`.
        case roleIds
    }

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedStatus: String {
        status.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public init(
        name: String = "",
        status: String,
        roleIds: [String]? = nil
    ) {
        self.name = name
        self.status = status
        self.roleIds = roleIds
    }

}
