import FeatherAdmin
import Foundation

public struct AdminAddUserIdentityFormInput: Codable, Sendable, Equatable,
    Hashable
{

    public let name: String
    public let status: String

    public init(
        name: String = "",
        status: String
    ) {
        self.name = name
        self.status = status
    }

}
