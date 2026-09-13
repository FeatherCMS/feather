import FeatherAdmin
import Foundation

public struct AdminAddUserIdentityFormInput: Decodable, Sendable, Equatable,
    Hashable
{

    public let name: String
    public let status: String

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedStatus: String {
        status.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public init(
        name: String = "",
        status: String
    ) {
        self.name = name
        self.status = status
    }

}
