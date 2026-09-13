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
        case roleIds
        case roleIdsArray = "roleIds[]"
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

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(String.self, forKey: .status)
        if let values = try? container.decodeIfPresent(
            [String].self,
            forKey: .roleIds
        ) {
            roleIds = values
        }
        else if let value = try? container.decodeIfPresent(
            String.self,
            forKey: .roleIds
        ) {
            roleIds = [value]
        }
        else {
            roleIds = try container.decodeIfPresent(
                [String].self,
                forKey: .roleIdsArray
            )
        }
    }

}
