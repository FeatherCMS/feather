import FeatherOpenAPI

extension Credential.Schemas {
    struct IdentityName: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialIdentityNameField" }
        var example: String? = "Root User"
    }
}
