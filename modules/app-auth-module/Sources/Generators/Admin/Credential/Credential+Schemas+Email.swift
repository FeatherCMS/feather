import FeatherOpenAPI

extension Credential.Schemas {
    struct Email: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialEmailField" }
        var example: String? = "john.doe@example.com"
    }
}
