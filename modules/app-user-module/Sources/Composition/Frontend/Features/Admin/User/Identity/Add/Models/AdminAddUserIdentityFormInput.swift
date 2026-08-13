import FeatherAdmin
import Foundation

public struct AdminAddUserIdentityFormInput: Codable, Sendable, Equatable,
    Hashable
{

    public let status: String

    public init(
        status: String
    ) {
        self.status = status
    }

}
