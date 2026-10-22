import FeatherOpenAPI
import OpenAPIKit30

extension Credential.Schemas {
    struct IdentityName: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialIdentityNameField" }
        var example: String? = "Root User"
    }
}
