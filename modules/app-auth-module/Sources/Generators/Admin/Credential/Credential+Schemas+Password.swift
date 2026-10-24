import FeatherOpenAPI
import OpenAPIKit30

extension Credential.Schemas {
    struct Password: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialPasswordField" }
        var example: String? = "correct-horse-battery-staple"
        var format: String? = "password"
    }
}
