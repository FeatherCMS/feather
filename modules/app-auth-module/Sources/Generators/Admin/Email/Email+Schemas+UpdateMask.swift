import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasUpdateMask" }
        var example: String? = "identityId,email"
    }
}
