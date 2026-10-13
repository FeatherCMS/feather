import FeatherContracts

public struct AdminEditUserIdentityFormInput: Decodable, Sendable, Equatable,
    Hashable
{

    public let name: String
    public let status: String
    public let roleIds: [String]

    var normalizedStatus: String {
        status.whitespaceTrimmed
    }

    var normalizedName: String {
        name.whitespaceTrimmed
    }

}
