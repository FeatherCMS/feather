public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct IdentityTag: TagRepresentable {
    public var name: String = "UserIdentities"
    public var description: String? = "User identities related endpoints."

    public init() {}
}
