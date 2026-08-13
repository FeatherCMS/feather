import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct AuthTag: TagRepresentable {
    public var name: String = "Auth"
    public var description: String? = "Authentication endpoints."

    public init() {}
}
