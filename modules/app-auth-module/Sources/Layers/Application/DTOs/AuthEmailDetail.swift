import AuthDomain
import FeatherApplication

public struct AuthEmailDetail: DTO, Sendable {
    public let id: String
    public let identityId: String
    public let email: String

    public init(_ model: AuthEmail) {
        id = model.id
        identityId = model.identityId
        email = model.email
    }
}
