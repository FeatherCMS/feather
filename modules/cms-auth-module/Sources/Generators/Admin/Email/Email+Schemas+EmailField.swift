import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.Schemas {
    struct EmailField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasEmailField" }
        var example: String? = "john.doe@example.com"
        var format: String? = "email"
    }
}
