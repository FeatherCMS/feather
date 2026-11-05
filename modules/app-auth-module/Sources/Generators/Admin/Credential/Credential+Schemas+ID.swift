import FeatherOpenAPI

extension Credential.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialIdField" }
        var example: String? = "credential_7nL3xQ2v"
    }
}
