import FeatherContracts

public struct AdminAddUserIdentityFormInput: Decodable, Sendable, Equatable,
    Hashable
{

    public let name: String
    public let status: String
    public let roleIds: [String]

    var normalizedName: String {
        name.whitespaceTrimmed
    }

    var normalizedStatus: String {
        status.whitespaceTrimmed
    }

    public init(
        name: String = "",
        status: String,
        roleIds: [String] = []
    ) {
        self.name = name
        self.status = status
        self.roleIds = roleIds
    }

}
