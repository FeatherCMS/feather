import AuthDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain

public struct IdentityEmailDetail: DTO, Sendable {
    public let id: String
    public let identityId: String
    public let email: String
    public let isPrimary: Bool
    public let isVerified: Bool

    public init(_ model: IdentityEmail) {
        id = model.id
        identityId = model.identityId
        email = model.email
        isPrimary = model.isPrimary
        isVerified = model.isVerified
    }
}
