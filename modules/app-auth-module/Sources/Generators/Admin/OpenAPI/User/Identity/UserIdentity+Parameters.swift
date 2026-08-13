import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct UserIdentitySessionIdParameter: PathParameterRepresentable {
    var name: String { "sessionId" }
    var description: String? { "Auth session id" }
    var schema: any OpenAPISchemaRepresentable {
        AuthSharedOpenAPIGenerator.UserAuthSessionIdField().reference()
    }
}
