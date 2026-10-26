import FeatherOpenAPI

extension Credential.Schemas {
    struct UserID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialUserIdField" }
        var example: String? = "user_7nL3xQ2v"
    }
}
