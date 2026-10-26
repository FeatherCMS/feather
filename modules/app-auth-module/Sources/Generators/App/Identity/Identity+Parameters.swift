public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct IdentityIdParameter: PathParameterRepresentable {
    public var openAPIIdentifier: String { "UserIdentityIdParameter" }
    public var name: String { "userIdentityId" }
    public var description: String? { "User identity id" }
    public var schema: any OpenAPISchemaRepresentable {
        IdentityIDField().reference()
    }

    public init() {}
}
