import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.Schemas {
    struct IDField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasIDField" }
        var example: String? = "email_7nL3xQ2v"
    }
}
