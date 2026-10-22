import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.Schemas {
    struct IDField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasIDField" }
        var example: String? = "email_7nL3xQ2v"
    }

    struct IdentityIDField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasIdentityIDField" }
        var example: String? = "user_7nL3xQ2v"
    }

    struct EmailField: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasEmailField" }
        var example: String? = "john.doe@example.com"
        var format: String? = "email"
    }

    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthEmailSchemasUpdateMask" }
        var example: String? = "identityId,email"
    }
}
