import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct UserIdentitySessionIdParameter: PathParameterRepresentable {
    var name: String { "sessionId" }
    var description: String? { "Auth session id" }
    var schema: any OpenAPISchemaRepresentable {
        UserIdentityIDField().reference()
    }
}
