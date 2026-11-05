import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.Schemas {
    struct IdentityIDField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasIdentityIDField" }
        var example: String? = "user_7nL3xQ2v"
    }
}
